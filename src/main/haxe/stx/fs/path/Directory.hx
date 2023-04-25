package stx.fs.path;

using eu.ohmrun.Pml;

using stx.fs.path.Directory;

//TODO change `attach` to something else
/**
  Represents an absolute path between the root of a file system
  to a known directory.
**/
typedef DirectoryDef = {
  var drive : Drive;
  var track : Track;
}
@:using(stx.fs.path.Directory.DirectoryLift)
@:forward abstract Directory(DirectoryDef) from DirectoryDef to DirectoryDef{
  public function new(self) this = self;
  static public var _(default,never) = DirectoryLift;
  
  @:noUsing static public function lift(self:DirectoryDef):Directory    return new Directory(self);
  @:noUsing static public function make(drive:Drive,track:Track):Directory{
    return Directory.lift({
      drive : drive,
      track : track
    });
  }
static public function fromArray(arr:Array<String>):Directory{
    return arr.head().flat_map(
      (str) -> (str.charAt(str.length - 1) == ":").if_else(
        () -> Some(str),
        () -> None
      )
    ).map(
      (str) -> make(Some(str),arr.tail())
    ).def(
      () -> make(None,arr)
    ).broker(
      F -> lift
    );
  }
  static public function parse(string:String){
    return Path.parse(string).attempt(Raw._.toDirectory);
  }
  public function attach():Command<HasDevice,FsFailure>       return _.attach(self);
  public function inject():Command<HasDevice,FsFailure>       return _.inject(self);

  public function exists():Attempt<HasDevice,Bool,FsFailure>  return _.exists(self);

  public function prj():DirectoryDef return this;
  private var self(get,never):Directory;
  private function get_self():Directory return lift(this);

  public function canonical(sep:Separator){
    var head    = this.drive.fold(
      (v) -> v + '$sep',
      () -> '$sep'
    );
    var body    = this.track.canonical(sep);
    __.log().debug(_ -> _.pure(head));
    __.log().debug(_ -> _.pure(body));
    return head + body;
  }
  public function toString():String{
    return canonical(cast "::");
  }
  public function components():Cluster<String>
    return this.drive.fold(
      (v) -> Track.pure(v).concat(this.track),
      ()  -> this.track
    );

  
  public function into(track:TrackDef):Directory{
    return make(this.drive,this.track.concat(track));
  }
  public function entry(entry:Entry):Archive{
    return Archive.make(this.drive,this.track,entry);
  }
  static public var pos = __.here();
}
class DirectoryLift{
  static public function eq(self:Directory):Eq<Directory>{
    return new stx.assert.eq.term.fs.path.Directory();
  }
  static public function down(self:Directory,next:String):Directory{
    return Directory.make(self.drive,self.track.snoc(next));
  }
  /**
    Returns a cluster of the files and directories
  **/
  static public function entries(self:Directory):Attempt<HasDevice,Cluster<Either<String,Entry>>,FsFailure>{
    return (env:HasDevice) -> {
      var sep     = env.device.sep;
      var path    = self.canonical(sep);
      var out     = __.reject(__.fault().of(E_Fs_AlreadyExists));
      return out  = __.accept(
        Cluster.lift(FileSystem.readDirectory(path)).map(
          (str:String) ->  FileSystem.isDirectory(self.into([str]).canonical(sep)).if_else(
            () -> stx.pico.Either.left(str),
            () -> stx.pico.Either.right(Entry.parse(str))
          )
        )
      );
    };
  }
  static public function files(self:Directory):Attempt<HasDevice,Cluster<String>,FsFailure>{
    return (env:HasDevice) -> {
      var sep     = env.device.sep;
      var path    = self.canonical(sep);
      return __.accept(
        Cluster.lift(
          FileSystem.readDirectory(path)
        ).map_filter(
          str -> FileSystem.isDirectory(self.into([str]).canonical(sep)).if_else(
            () -> Some(str),
            () -> None
          )
        )
      );
    };
  }
  static public function directories(self:Directory):Attempt<HasDevice,Cluster<String>,FsFailure>{
    return (env:HasDevice) -> {
      var sep     = env.device.sep;
      var path    = self.canonical(sep);
      return __.accept(
        Cluster.lift(
          FileSystem.readDirectory(path)
        ).map_filter(
          str -> FileSystem.isDirectory(self.into([str]).canonical(sep)).if_else(
            () -> None,
            () -> Some(str)
          )
        )
      );
    };
  }
  /**
    Attaches the directory to the file system in HasDevice.
  **/
  static public function attach(self:Directory):Command<HasDevice,FsFailure>{
    return __.command((env:HasDevice) -> {
      var str = self.canonical(env.device.sep);
      return try{
        FileSystem.createDirectory(str);
        Report.unit();
      }catch(e:Dynamic){
        Report.pure(__.fault().of(E_Fs_CannotCreate(str)));
      }
    });
  }
  /**
    Attaches the directory to the Device if it does not exist.
  **/
  static public function ensure(self:Directory):Command<HasDevice,FsFailure>{
    return exists(self).reframe().commandeer(
      (bool:Bool) -> bool.if_else(
        () -> Command.unit(),
        () -> inject(self)
      )
    );
  }
  /**
    Attaches the directory to the Device no matter how many intermediary directories need creating.
  **/
  static public function inject(self:Directory):Command<HasDevice,FsFailure>{
    trace(self);
    return Command.fromFun1Execute((env:HasDevice) -> {
      __.log().debug("inject:0");
      return Execute.bind_fold(
        (next:Array<String>,memo:Report<FsFailure>) -> {
          __.log().trace('inject');
          var path = Directory.fromArray(next);
          return memo.fold(
            (v:Refuse<FsFailure>) -> Execute.pure(v),
            ()  -> exists(path).provide(env).point(
              (b) -> b.if_else(
                () -> Execute.unit(),//TODO wtf
                () -> attach(path).provide(env)
              )
            )
          );
        },
        self.components().lfold(
          (next:String,memo:Array<Array<String>>) -> 
            memo.is_defined().if_else(
              () -> memo.snoc(
                memo[memo.length-1].snoc(next)
              ),
              () -> memo.snoc([next])
            ),
          []
        )
      );
    });
  }

  static public function exists(self:Directory):Attempt<HasDevice,Bool,FsFailure>{
    return (env:HasDevice) -> try{
      __.accept(FileSystem.exists(self.canonical(env.device.sep)));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_Fs_UnknownFSError(e)));
    }  
  }
  static public function parent(self:Directory):Produce<Directory,FsFailure>{
    var fn = () -> {
      var track = self.track.snapshot().rdropn(1);

      return Directory.make(
        self.drive,
        track
      );
    };
    return Produce.fromFunXR(fn).errata(
      (e) -> e.fault().of(E_Fs_UnknownFSError(e.data))
    );
  }
  static public function tree(dir:Directory):Modulate<HasDevice,PExpr<Entry>,FsFailure>{
    __.log().trace('tree: $dir');
    var init  = Arrange.fromFun1Attempt(entries);
    var c     = Modulate.pure(dir).reframe().arrange(entries);
    
    function fn(either:Either<String,Entry>,t:PExpr<Entry>):Modulate<HasDevice,PExpr<Entry>,FsFailure>{
      __.log().trace(_ -> _.pure(either));
      return switch(either){
        case Left(string) : 
          var into = dir.into([string]);
          $type(into);
          __.log().trace(_ -> _.pure(into));
          var next = tree(into);
          __.log().trace(_ -> _.pure(next));
          
          
          final rest = next.arrange(
            __.arrange(
              (t1:PExpr<Entry>) -> {
                return __.convert(function(dev:HasDevice){
                  final split = string.split(dev.device.sep);
                  final entry = Entry.make(split[0],split[1]);
                  return switch(t){
                    case PArray(arr) : PArray(arr.snoc(PValue(entry)).snoc(t1));
                    case PEmpty      : PArray([PValue(entry),t1]);
                    default          : PArray([PValue(entry),t1]);
                  }
                }); 
              }
            )
          );
          $type(rest);
        case Right(entry) : Modulate.pure(
          switch(t){
            case PArray(arr) : PArray(arr.snoc(PValue(entry)));
            case PEmpty      : PArray([PValue(entry)]);
            default          : PArray([PValue(entry)]);
          }
        );
      }
    }
    var ut  = Arrange.pure(PEmpty);
    var d   = Arrange.bind_fold.bind(fn).fn().then( _ -> _.defv(ut));
    var e   = c.arrangement(d).toModulate();
    var f = e.mapi(
      (env) -> __.couple(PEmpty,env)
    );
    //$type(a);
    // $type(b);
    //$type(c);
    // $type(fn);
    //$type(d);
    //$type(e);
    //$type(f);
    return Modulate.lift(f);
  }
  //TODO: I should probably `HasDevice` this.
  static public function search_ancestors(self:Directory,arw:Modulate<HasDevice & EnquireDef<Directory>,Bool,FsFailure>):Modulate<HasDevice,Option<Directory>,FsFailure>{
    return Modulate.fromFun1Produce((state:HasDevice) -> return arw.flat_map(
    (
        (b:Bool) -> b.if_else(
          () -> Modulate.pure(Some(self)),
          () -> self.parent().toModulate().modulate(
            Modulate.fromFun1Produce(
              (that:Directory) -> eq(self).comply(self,that).is_ok().if_else(
                () -> Produce.pure(None),
                () -> search_ancestors(that,arw).produce(__.accept(state))
              )
            )
          )
        )
      )
    ).produce(__.accept({ device : state.device, enquire : self })));
  }

  @:noUsing static public inline function into(self:Directory,track:TrackDef):Directory{
    return self.into(track);
  }
  static public function archive(self:Directory,that:Attachment):Upshot<Archive,FsFailure>{
    return that.track.lfold(
      (next:Move,memo:Upshot<Track,FsFailure>) -> switch([next,memo]){
          case [Into(name),Accept(dir)] : __.accept(dir.concat([name]));
          case [From,Accept(dir)]       : dir.up().errate(e -> (e:FsFailure));
          case [_,Reject(_)]            : memo;
      },
      __.accept(self.track)
    ).map(
      (next:Track) -> Archive.lift({
        drive : self.drive,
        track : next,
        entry : that.entry
      })
    );
  }
  
  static public function is_root(self:Directory):Bool{
    return !self.track.is_defined();
  }
  // static public function up(self:Directory){
  //   return is_root(self).if_else(
  //     () -> __.reject(__.fault().of(E_Path_ReachedRoot).errate(e -> (e:FsFailure))),
  //     () -> self.track.up().map(track -> Dir.make(dir.drive,track))
  //   );
  // }
  static public function toAddress(self:DirectoryDef):Address{
    return Address.make(self.drive,self.track,None);
  }
}