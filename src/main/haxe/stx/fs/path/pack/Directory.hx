package stx.fs.path.pack;

using eu.ohmrun.Pml;

using stx.fs.path.pack.Directory;

/**
  Represents an absolute path between the root of a file system
  to a known directory.
**/
typedef DirectoryDef = {
  var drive : Drive;
  var track : Track;
}
@:using(stx.fs.path.pack.Directory.DirectoryLift)
@:forward abstract Directory(DirectoryDef) from DirectoryDef to DirectoryDef{
  public function new(self) this = self;
  static public var _(default,never) = DirectoryLift;
  
  
  static public function lift(self:DirectoryDef):Directory    return new Directory(self);
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
  public function attach():Command<HasDevice,FsFailure>       return _.attach(self);
  public function inject():Command<HasDevice,FsFailure>       return _.inject(self);

  public function exists():Attempt<HasDevice,Bool,FsFailure>  return _.exists(self);

  public function prj():DirectoryDef return this;
  private var self(get,never):Directory;
  private function get_self():Directory return lift(this);

  public function canonical(sep:Separator){
    var head    = this.drive.fold(
      (v) -> v + sep,
      () -> sep
    );
    var body    = this.track.join(sep);
    return head + body;
  }
  public function toString():String{
    return canonical(cast "::");
  }
  public function components():Array<String>
    return this.drive.fold(
      (v) -> [v].concat(this.track),
      () -> this.track
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
  static public function down(self:Directory,next:String):Directory{
    return Directory.make(self.drive,self.track.snoc(next));
  }
  static public function entries(self:Directory):Attempt<HasDevice,Array<Either<String,Entry>>,FsFailure>{
    return (env:HasDevice) -> {
      var sep     = env.device.sep;
      var path    = self.canonical(sep);
      var out     = __.reject(__.fault().of(AlreadyExists));
      return out  = __.accept(
        FileSystem.readDirectory(path).map(
          (str:String) ->  FileSystem.isDirectory(self.into([str]).canonical(sep)).if_else(
            () -> stx.pico.Either.left(str),
            () -> stx.pico.Either.right(Entry.parse(str))
          )
        )
      );
    };
  }
  static public function attach(self:Directory):Command<HasDevice,FsFailure>{
    return (env:HasDevice) -> {
      var str = self.canonical(env.device.sep);
      return try{
        FileSystem.createDirectory(str);
        Report.unit();
      }catch(e:Dynamic){
        Report.pure(__.fault().of(CannotCreate(str)));
      }
    };
  }
  static public function ensure(self:Directory):Command<HasDevice,FsFailure>{
    return exists(self).reframe().commandeer(
      (bool:Bool) -> bool.if_else(
        () -> Command.unit(),
        () -> inject(self)
      )
    );
  }
  static public function inject(self:Directory):Command<HasDevice,FsFailure>{
    return (env:HasDevice) -> {
      return Execute.bind_fold(
        (next:Array<String>,memo:Report<FsFailure>) -> {
          var path = Directory.fromArray(next);
          return memo.fold(
            (v:Rejection<FsFailure>) -> Execute.pure(v),
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
    }
  }

  static public function exists(self:Directory):Attempt<HasDevice,Bool,FsFailure>{
    return (env:HasDevice) -> try{
      __.accept(FileSystem.exists(self.canonical(env.device.sep)));
    }catch(e:Dynamic){
      __.reject(__.fault().of(UnknownFSError(e)));
    }  
  }
  static public function parent(self:Directory):Produce<Directory,FsFailure>{
    var fn = () -> {
      var track = self.track.snapshot();
          track.pop();

      return Directory.make(
        self.drive,
        track
      );
    };
    return Produce.fromFunXR(fn).errata(
      (e) -> e.fault().of(UnknownFSError(e.data))
    );
  }
  static public function tree(dir:Directory):Cascade<HasDevice,Expr<Entry>,FsFailure>{
    __.log().debug('tree: $dir');
    var init  = Arrange.fromFun1Attempt(entries);
    var c     = Cascade.pure(dir).reframe().arrange(entries);
    
    function fn(either:Either<String,Entry>,t:Expr<Entry>):Cascade<HasDevice,Expr<Entry>,FsFailure>{
      __.log().debug(_ -> _.pure(either));
      return switch(either){
        case Left(string) : 
          var into = dir.into([string]);
          __.log().debug(_ -> _.pure(into));
          var next = tree(into);
          __.log().debug(_ -> _.pure(next));
          
          next.convert(
            function(t1){
              return t.conflate(Group(Cons(Label(string),Cons(t1,Nil))));
            }
          );
        case Right(entry) : Cascade.pure(
            t.conflate(Value(entry))
          );
      }
    }
    var ut  = Arrange.pure(Empty);
    var d   = Arrange.bind_fold.bind(fn).fn().then( _ -> _.defv(ut));
    var e   = c.arrangement(d).toCascade();
    var f = e.mapi(
      (env) -> __.couple(Empty,env)
    );
    //$type(a);
    // $type(b);
    //$type(c);
    // $type(fn);
    //$type(d);
    //$type(e);
    //$type(f);

    return Cascade.lift(f);
  }
}