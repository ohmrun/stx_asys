package stx.fs.path;

@:using(stx.fs.path.Raw.RawLift)
@:forward(head,tail,length,lfold,last) abstract Raw(RawDef) from RawDef to RawDef{
  static public var _(default,never) = RawLift;
  public function new(self) this = self;
  @:noUsing static public function lift(self:RawDef):Raw return new Raw(self);
	static public function unit():Raw{
		return lift(Cluster.unit());
	}
  @:arrayAccess
  public function at(i:Int){
    return this[i];
  }
  public function prj():RawDef return this;
  private var self(get,never):Raw;
  private function get_self():Raw return lift(this);

	public function snoc(token:Token):Raw{
		return lift(this.snoc(token));
	}
	public function rdropn(n):Raw{
		return lift(this.rdropn(n));
	} 
}


class RawLift {
	static public function canonical(self:Raw,sep:Separator){
		return self.prj().map(token -> token.canonical(sep)).lfold1((x,y) -> '${x}${y}').defv(".");
	}
  static public function toJourney(arr:Raw):Res<Journey,PathFailure>{
		var head = arr.head();
		var rest = arr.tail();
		return switch(head){
			case None :
				__.accept(Journey.unit());
			case Some(v) :
				var is_denormalized 					= false;
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
						is_denormalized = true;
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
						case FPTSep 					: 
						case FPTDrive(name) 	:
							error = __.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode));
						case FPTRel 					:
							error = __.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode));
						case FPTUp 						:
							body.prj().push(From);
						case FPTDown(str) 		:
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
					var track = if(!is_denormalized){
						Track.lift(body.map(
							(x) -> switch(x){
								case Into(v) : v;
								default: '';
							}
						));
					}else{
						Track.unit();
					}
					__.accept(Journey.make(
						head,
						is_denormalized.if_else(
							() -> Left(Route.fromArray(body)),
							() -> Right(track)
						),
						tail
					));
				}
		}
	}
	static public function toDirectory(raw:Raw):Produce<Directory,PathFailure>{
		__.log().debug(_ -> _.pure(raw));
		return __.produce(switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				__.log().debug(_ -> _.pure(drive));
				var track 				= raw.tail().lfold(
					(next:Token,memo:Res<Cluster<String>,PathFailure>) -> memo.fold(
						(arr) -> switch(__.log().level(TRACE).through()(next)){
							case FPTDrive(_) 	: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedDenormalizedPath(raw))));
							case FPTSep				: __.accept(arr);
							case FPTDown(str) : __.accept(arr.snoc(str));
							case FPTFile(_,_) : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedFileInDirectory(raw))));
						},
						(err) -> __.reject(err)
					),
					__.accept([])
				);
				__.log().debug(_ -> _.pure(track));
				track.map(
					(track:Track) -> Directory.make(drive,track)
				);
			default : 
					__.log().debug(_ -> _.pure(raw.head()));
					__.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoHeadNode)));
		});
	}
	//TODO eek out filename from new parsing conventions
	static public function toAttachment(raw:Raw):Res<Attachment,PathFailure>{
		__.log().debug(_ -> _.pure(raw.head()));
		final data = (switch(raw.head()){
			case Some(FPTRel)						: __.accept(raw.tail());
			case Some(FPTDown(string))	: __.accept(raw);
			default : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))));
		});

		final last = (raw.last().resolve(_ -> _.of((E_PathParse_MalformedRaw(raw):PathFailure))));
		
		return data.map(c -> c.rdropn(1)).flat_map(
			raw -> raw.lfold(
					(next:Token,memo:Res<MaybeAttachment,PathFailure>) -> memo.fold(
						(v) -> switch(next){
							case FPTDrive(_) 	: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp				: __.accept(v.snoc(From));
							case FPTDown(str) : __.accept(v.snoc(Into(str)));
							case FPTFile(n,e) : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))));
							case FPTSep				: __.accept(v);
						},
						__.reject
					),
					__.accept(new MaybeAttachment())
				).flat_map(
					(x) -> last.map(y -> __.couple(Entry.fromToken(y),x))
				).flat_map(
					(x) -> x.fst().fold(
						(drive) -> __.accept(Attachment.make((drive),x.snd().snd())),
						() 			-> __.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoFileFoundOnAttachment(raw))))
					)
				)
		);
	}
	static public function toAddress(raw:Raw):Res<Address,PathFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var entry 				= raw.last();
				var track = raw.tail().rdropn(1).lfold(
					(next:Token,memo:Res<Cluster<String>,PathFailure>) -> memo.fold(
						(tp) -> switch(next){
							case FPTDrive(_) 				: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTRel							: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MisplacedHeadNode)));
							case FPTUp							: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_UnexpectedDenormalizedPath(raw))));
							case FPTSep							: memo;
							case FPTDown(str) 			: memo.map( arr -> arr.snoc(str));
							case FPTFile(nm,ext) 	  : __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))));
						},
						__.reject
					),
					__.accept(Cluster.unit())
				);
				track.flat_map(
					cluster -> entry.fold(
						token -> switch(token){
							case FPTDown(str) 		: __.accept(__.couple(None,cluster.snoc(str)));
							case FPTFile(nm,ext)	: __.accept(__.couple(Some(Entry.make(nm,ext)),cluster));
							case FPTSep						: __.accept(__.couple(None,cluster));
							default 							: __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))));
						},
						() -> __.reject(__.fault().of(E_Path_PathParse(E_PathParse_MalformedRaw(raw))))
					)
				).map(
					(entry) -> Address.make(drive,entry.snd(),entry.fst())
				);
			default : 
					__.reject(__.fault().of(E_Path_PathParse(E_PathParse_NoHeadNode)));
		});
	}
	static public function toArchive(raw:Raw):Res<Archive,PathFailure>{
		return toAddress(raw).adjust(
			(address) -> address.entry.fold(
				ok -> __.accept(Archive.make(address.drive,address.track,ok)),
				() -> __.reject(__.fault().of(E_Path_PathParse(E_PathParse_ExpectedEntry(raw))))
			)
		);
	}
	static public function kind(arr:Raw):Kind{
    var absolute              = false;
    var normalized            = true;
    var has_trailing_slash    = false;
		var file 									= Nay;
    for(i in 0...arr.length){
      var token = arr[i];
      if(i == 0){
        absolute = token.prj().match(FPTDrive(None));
      }
      if(token == FPTUp){
        normalized = false;
      }
      if(i == arr.length-1){
        has_trailing_slash = token.prj().match(FPTSep);
				file = switch(token){
					case FPTDown(_) 			: Maybe;
					case FPTFile(_,_) 		: Yay;
					default 							: Nay;
				}
      }
    };
    return {
      absolute              : absolute,
      normalized            : normalized,
      has_trailing_slash    : has_trailing_slash,
      file                  : file
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
	static public function absolutize(self:Raw):Attempt<HasDevice,Address,FsFailure>{
		return __.attempt(
			(state:HasDevice) -> {
				final kind = kind(self);
				if(!kind.normalized){
					self = normalize(self);
				}
				final a = if(!kind.absolute){
					state.device.shell.cwd.pop().adjust(
						(dir) -> toTrack(self).map(
							track -> dir.into(track)
						).errate(e -> (e:FsFailure))
					).map(
						(dir) -> dir.toAddress()
					);
				}else{
					__.attempt( (s:HasDevice) -> toAddress(self) ).errate(e -> (e:FsFailure));
				}
				return a.produce(state);
			}
		); 
	}
	static public function normalize(self:Raw){
		final rest = self.lfold(
			(next:Token,memo:Raw) -> switch(next){
					case FPTUp 														: 
							memo.rdropn(1);
					case FPTDrive(_) | FPTRel | FPTSep | FPTDown(_) | FPTFile(_,_) : 
						memo.snoc(next);
				},
			Raw.unit()
		);
		return rest;
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
	public function name(entry:stx.fs.path.Entry){
		return lift(
			this.mapl(
				(_) -> Some(entry)
			)
		);
	}
}
