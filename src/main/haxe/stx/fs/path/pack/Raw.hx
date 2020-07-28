package stx.fs.path.pack;

@:using(stx.fs.path.pack.Raw.RawLift)
@:forward(head,tail,length) abstract Raw(RawDef) from RawDef to RawDef{
  static public var _(default,never) = RawLift;
  public function new(self) this = self;
  static public function lift(self:RawDef):Raw return new Raw(self);
  
  @:arrayAccess
  public function at(i:Int){
    return this[i];
  }
  public function prj():RawDef return this;
  private var self(get,never):Raw;
  private function get_self():Raw return lift(this);
}


class RawLift {
  static public function toAddress(arr:Raw):Res<Address,PathFailure>{
		var head = arr.head();
		var rest = arr.tail();
		return switch(head){
			case None :
				__.accept(Address.unit());
			case Some(v) :
				var is_denormalised 					= false;
				var is_absolute 							= false;
				var head : Stem								= Here;
				var body : Array<Move> 				= [];
				var tail  										= None;
				var error 										= null;

				switch(v){
					case FPTDrive(drive) 				:
						is_absolute = true;
						head 				= Root(drive);
  				case FPTUp									:
						is_denormalised = true;
						body.prj().push(From);
					case FPTFile(str, null)			:
						tail 	= Some(Entry.fromName(str));
					case FPTFile(str,ext)				:
						tail = Some(Entry.lift({
							name 	: str,
							ext 	: ext
						}));
					case FPTDown(str):
						body.prj().push(Into(str));
					case FPTRel:
					default : 
						trace(v);
						error = __.fault().of(E_Path_PathParse(E_PathParse_NoHeadNode));
				}
				for(node in rest){
					switch (node){
						case FPTSep : 
						case FPTDrive(name):
							error = __.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode));
						case FPTRel:
							error = __.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode));
						case FPTUp:
							body.prj().push(From);
						case FPTDown(str):
							body.prj().push(Into(str));
						case FPTFile(str,null):
							tail = Some(Entry.fromName(str));
						case FPTFile(str, ext):
							tail = Some(Entry.lift({
								name : str,
								ext  : ext
							}));
					}
				}
				if(error!=null){
					__.reject(error);
				}else{
					var track = if(!is_denormalised){
						Track.lift(body.map(
							(x) -> switch(x){
								case Into(v) : v;
								default: '';
							}
						));
					}else{
						[];
					}
					__.accept(Address.make(
						head,
						is_denormalised.if_else(
							() -> Left(body),
							() -> Right(track)
						),
						tail
					));
				}
		}
	}
	static public function toDirectory(raw:Raw):Proceed<Directory,PathFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var track = raw.tail().lfold(
					(next:Token,memo:Res<Array<String>,PathFailure>) -> memo.fold(
						(arr) -> switch(next){
							case FPTDrive(_) 	: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedDenormalisedPath(raw))));
							case FPTSep				: __.accept(arr);
							case FPTDown(str) : __.accept(arr.snoc(str));
							case FPTFile(_,_) : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedFileInDirectory(raw))));
						},
						(err) -> __.reject(err)
					),
					__.accept([])
				);
				track.map(
					(track:Track) -> Directory.make(drive,track)
				);
			default : 
					__.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoHeadNode)));
		}).broker(
			F -> F.then(Proceed.fromRes).then(
				(io) -> io
			)
		);
	}
	static public function toAttachment(raw:Raw):Res<Attachment,PathFailure>{
		return switch(raw.head()){
			case Some(FPTRel)				: 
				Res.lift(raw.tail().lfold(
					(next:Token,memo:Res<MaybeAttachment,PathFailure>) -> memo.fold(
						(v) -> switch(next){
							case FPTDrive(_) 	: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp				: __.accept(v.snoc(From));
							case FPTDown(str) : __.accept(v.snoc(Into(str)));
							case FPTFile(n,e) : __.accept(v.name({ name : n, ext : e }));
							case FPTSep				: __.accept(v);
						},
						__.reject
					),
					__.accept(new MaybeAttachment())
				)).flat_map(
					(x) -> x.fst().fold(
						(drive) -> __.accept(Attachment.make(drive,x.snd())),
						() 			-> __.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoFileFoundOnAttachment(raw))))
					)
				);
			default : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))));
		}
	}
	static public function toArchive(raw:Raw):Res<Archive,PathFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var track = raw.tail().lfold(
					(next:Token,memo:Res<Couple<Option<Entry>,Array<String>>,PathFailure>) -> memo.fold(
						(tp) -> switch(next){
							case FPTDrive(_) 				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel							: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp							: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedDenormalisedPath(raw))));
							case FPTSep							: __.accept(tp);
							case FPTDown(str) 			: __.accept(tp.map(arr->arr.snoc(str)));
							case FPTFile(nm,null) 	: __.accept(tp.map(arr->arr.snoc(nm)));
							case FPTFile(nm,ext) 	  : __.accept(tp.lmap(_ -> __.option(Entry.make(nm,ext))));
						},
						__.reject
					),
					__.accept(__.couple(__.option(null),[]))
				);
				track.fold(
					(tp) -> tp.fst().fold(
						(entry) -> __.accept(Archive.make(drive,tp.snd(),entry)),
						()			-> __.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoFileOnPath(raw))))
					),
					__.reject
				);
			default : 
					__.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoHeadNode)));
		});
	}
	static public function kind(arr:Raw){
    var absolute              = false;
    var normalised            = true;
    var has_trailing_slash    = false;
    for(i in 0...arr.length){
      var token = arr[i];
      if(i == 0){
        absolute = token.match(FPTDrive(None));
      }
      if(token == FPTUp){
        normalised = false;
      }
      if(i == arr.length-1){
        has_trailing_slash = token.match(FPTSep);
      }
    };
    return {
      absolute              : absolute,
      normalised            : normalised,
      has_trailing_slash    : has_trailing_slash,
      file                  : false
    }
	}
	static public function toTrack(raw:Raw):Res<Track,PathFailure>{
		return raw.lfold(
			(next:Token,memo:Res<Track,PathFailure>) -> memo.fold(
				(arr) -> switch(next){
					case FPTDown(str) : __.accept(arr.snoc(str));
					case FPTSep  			: __.accept(arr);
					default 					: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedToken(next,raw))));
				},
				__.reject
			),
			__.accept([])
		);
	}
}

@:forward abstract MaybeAttachment(Couple<Option<Entry>,Route>){
	static public function lift(clause:Couple<Option<Entry>,Route>):MaybeAttachment{
		return new MaybeAttachment(clause);
	}
	public function new(?self:Couple<Option<Entry>,Route>){
		this = __.option(self).defv(__.couple(None,new Route([])));
	}
	public function snoc(v:Move){
		return lift(
			this.map(
				(r) -> r.snoc(v)
			)
		);
	}
	public function name(entry:Entry){
		return lift(
			this.lmap(
				(_) -> Some(entry)
			)
		);
	}
}