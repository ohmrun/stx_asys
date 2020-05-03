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
				__.success(Address.unit());
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
						error = __.fault().of(ParseFailed(NoHeadNode));
				}
				for(node in rest){
					switch (node){
						case FPTSep : 
						case FPTDrive(name):
							error = __.fault().of(ParseFailed(MisplacedHeadNode));
						case FPTRel:
							error = __.fault().of(ParseFailed(MisplacedHeadNode));
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
					__.failure(error);
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
					__.success(Address.make(
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
							case FPTDrive(_) 	: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTRel				: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTUp				: __.failure(__.fault().of(ParseFailed(UnexpectedDenormalisedPath(raw))));
							case FPTSep				: __.success(arr);
							case FPTDown(str) : __.success(arr.snoc(str));
							case FPTFile(_,_) : __.failure(__.fault().of(ParseFailed(UnexpectedFileInDirectory(raw))));
						},
						(err) -> __.failure(err)
					),
					__.success([])
				);
				track.map(
					(track:Track) -> Directory.make(drive,track)
				);
			default : 
					__.failure(__.fault().of(ParseFailed(NoHeadNode)));
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
							case FPTDrive(_) 	: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTRel				: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTUp				: __.success(v.snoc(From));
							case FPTDown(str) : __.success(v.snoc(Into(str)));
							case FPTFile(n,e) : __.success(v.name({ name : n, ext : e }));
							case FPTSep				: __.success(v);
						},
						__.failure
					),
					__.success(new MaybeAttachment())
				)).flat_map(
					(x) -> x.fst().fold(
						(drive) -> __.success(Attachment.make(drive,x.snd())),
						() 			-> __.failure(__.fault().of(ParseFailed(NoFileFoundOnAttachment(raw))))
					)
				);
			default : __.failure(__.fault().of(ParseFailed(MalformedRaw(raw))));
		}
	}
	static public function toArchive(raw:Raw):Res<Archive,PathFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var track = raw.tail().lfold(
					(next:Token,memo:Res<Couple<Option<Entry>,Array<String>>,PathFailure>) -> memo.fold(
						(tp) -> switch(next){
							case FPTDrive(_) 				: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTRel							: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTUp							: __.failure(__.fault().of(ParseFailed(UnexpectedDenormalisedPath(raw))));
							case FPTSep							: __.success(tp);
							case FPTDown(str) 			: __.success(tp.map(arr->arr.snoc(str)));
							case FPTFile(nm,null) 	: __.success(tp.map(arr->arr.snoc(nm)));
							case FPTFile(nm,ext) 	  : __.success(tp.lmap(_ -> __.option(Entry.make(nm,ext))));
						},
						__.failure
					),
					__.success(__.couple(__.option(null),[]))
				);
				track.fold(
					(tp) -> tp.fst().fold(
						(entry) -> __.success(Archive.make(drive,tp.snd(),entry)),
						()			-> __.failure(__.fault().of(ParseFailed(NoFileOnPath(raw))))
					),
					__.failure
				);
			default : 
					__.failure(__.fault().of(ParseFailed(NoHeadNode)));
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