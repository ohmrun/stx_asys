package stx.fs.path.parse.body;

class Raws extends Clazz{
  public function toAddress(arr:Raw):Outcome<Address,AddressFailure>{
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
	public function toDirectory(raw:Raw):Proceed<Directory,AddressFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var track = raw.tail().lfold(
					(next:Token,memo:Outcome<Array<String>,AddressFailure>) -> memo.fold(
						(arr) -> switch(next){
							case FPTDrive(_) 	: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTRel				: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTUp				: __.failure(__.fault().of(ParseFailed(UnexpectedDenormalisedAddress(raw))));
							case FPTSep				: __.success(arr);
							case FPTDown(str) : __.success(arr.snoc(str));
							case FPTFile(_,_) : __.failure(__.fault().of(ParseFailed(UnexpectedFileInDirectory(raw))));
						},
						(err) -> __.failure(err)
					),
					__.success([].ds())
				);
				track.map(
					(track:Track) -> Directory.make(drive,track)
				);
			default : 
					__.failure(__.fault().of(ParseFailed(NoHeadNode)));
		}).broker(
			F -> F.then(Proceed.fromOutcome).then(
				(io) -> io.map(__.tracer())
			)
		);
	}
	public function toAttachment(raw:Raw):Res<Attachment,AddressFailure>{
		return switch(raw.head()){
			case Some(FPTRel)				: 
				Res.lift(raw.tail().lfold(
					(next:Token,memo:Res<MaybeAttachment,AddressFailure>) -> memo.fold(
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
					(x) -> x.brand.fold(
						(brand) -> __.success(Attachment.lift(Clause.make(brand,x.media))),
						() 			-> __.failure(__.fault().of(ParseFailed(NoFileFoundOnAttachment(raw))))
					)
				);
			default : __.failure(__.fault().of(ParseFailed(MalformedRaw(raw))));
		}
	}
	public function toArchive(raw:Raw):Outcome<Archive,AddressFailure>{
		return (switch(raw.head()){
			case Some(FPTDrive(head)) : 
				var drive : Drive = head;
				var track = raw.tail().lfold(
					(next:Token,memo:Outcome<Couple<Option<Entry>,Array<String>>,AddressFailure>) -> memo.fold(
						(tp) -> switch(next){
							case FPTDrive(_) 				: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTRel							: __.failure(__.fault().of(ParseFailed(MisplacedHeadNode)));
							case FPTUp							: __.failure(__.fault().of(ParseFailed(UnexpectedDenormalisedAddress(raw))));
							case FPTSep							: __.success(tp);
							case FPTDown(str) 			: __.success(tp.map(arr->arr.snoc(str)));
							case FPTFile(nm,null) 	: __.success(tp.map(arr->arr.snoc(nm)));
							case FPTFile(nm,ext) 	  : __.success(tuple2(Some(Entry.make(nm,ext)).core(),tp.snd()));
						},
						__.failure
					),
					__.success(tuple2(None.core(),[].ds()))
				);
				track.fold(
					(tp) -> tp.fst().fold(
						(entry) -> __.success(Archive.make(drive,tp.snd(),entry)),
						()			-> __.failure(__.fault().of(ParseFailed(NoFileOnAddress(raw))))
					),
					__.failure
				);
			default : 
					__.failure(__.fault().of(ParseFailed(NoHeadNode)));
		});
	}
	public function kind(arr:Raw){
    var absolute              = false;
    var normalised            = true;
    var has_trailing_slash    = false;
    for(i in 0...arr.length){
      var token = arr[i];
      if(i == 0){
        absolute = new EnumValue(token).alike(FPTDrive(None));
      }
      if(token == FPTUp){
        normalised = false;
      }
      if(i == arr.length-1){
        has_trailing_slash = new EnumValue(token).alike(FPTSep);
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

@:forward abstract MaybeAttachment(Clause<Option<Entry>,Route>){
	static public function lift(clause:Clause<Option<Entry>,Route>):MaybeAttachment{
		return new MaybeAttachment(clause);
	}
	public function new(?self:Clause<Option<Entry>,Route>){
		this = __.option(self).defv(Clause.make(None.core(),new Route([])));
	}
	public function snoc(v:Move){
		return lift(Clauses._.copy(this.brand,this.media.snoc(v),this));
	}
	public function name(entry:Entry){
		return lift(Clauses._.copy(Some(entry).core(),this.media,this));
	}
}