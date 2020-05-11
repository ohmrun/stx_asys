package stx.fs.path.pack;

/**
  Represents an absolute path between the root of a file system
  to a known directory 
**/
typedef DirectoryDef = {
  var drive : Drive;
  var track : Track;
}

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
  public function attach():Command<HasDevice,FSFailure>       return _.attach(self);
  public function inject():Command<HasDevice,FSFailure>       return _.inject(self);

  public function exists():Attempt<HasDevice,Bool,FSFailure>       return _.exists(self);

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
  public function entries():Attempt<HasDevice,Array<Either<String,Entry>>,FSFailure>{
    return _.entries(this);
  }
  static public var pos = __.here();
}
private class DirectoryLift{

  static public function entries(self:Directory):Attempt<HasDevice,Array<Either<String,Entry>>,FSFailure>{
    return (env:HasDevice) -> {
      var sep     = env.device.sep;
      var path    = self.canonical(sep);
      var out     = __.failure(__.fault().of(AlreadyExists));
      return out  = __.success(
        FileSystem.readDirectory(path).map(
          (str:String) ->  FileSystem.isDirectory(self.into([str]).canonical(sep)).if_else(
            () -> __.left(str),
            () -> __.right(Entry.parse(str))
          )
        )
      );
    };
  }
  static public function attach(self:Directory):Command<HasDevice,FSFailure>{
    return (env:HasDevice) -> {
      var str = self.canonical(env.device.sep);
      return try{
        FileSystem.createDirectory(str);
        Report.unit();
      }catch(e:Dynamic){
        Report.pure(__.fault().of(FSFailure.CannotCreate(str)));
      }
    };
  }
  static public function inject(self:Directory):Command<HasDevice,FSFailure>{
    return (env:HasDevice) -> {
      return Execute.bind_fold(
        (next:Array<String>,memo:Report<FSFailure>) -> {
          var path = Directory.fromArray(next);
          return memo.fold(
            (v:Err<FSFailure>) -> Execute.pure(v),
            ()  -> exists(path).forward(env).point(
              (b) -> b.if_else(
                () -> cast Execute.unit(),//TODO wtf
                () -> attach(path).forward(env)
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

  static public function exists(self:Directory):Attempt<HasDevice,Bool,FSFailure>{
    return (env:HasDevice) -> try{
      __.success(FileSystem.exists(self.canonical(env.device.sep)));
    }catch(e:Dynamic){
      __.failure(__.fault().of(UnknownFSError(e)));
    }  
  }
  static public function parent(self:Directory):Proceed<Directory,FSFailure>{
    var fn = () -> {
      var track = self.track.snapshot();
          track.pop();

      return Directory.make(
        self.drive,
        track
      );
    };
    return Proceed.fromFunXR(fn).errata(
      (e) -> e.fault().of(UnknownFSError(e.data))
    );
  }
  static public function tree(dir:Directory):Attempt<HasDevice,Jali<Entry>,Dynamic>{
    __.log().close()('Jali: $dir');
    var init  = Arrange.fromFun1Attempt(entries);
    var pure  = (entry) -> Jali.make().datum(entry);
    var make  = Jali.make();
    var c     = Cascade.pure(__.success(dir)).reframe().arrange(entries);
    
    function fn(either:Either<String,Entry>,t:Jali<Entry>){
      __.log().close().trace(either);
      return switch(either){
        case Left(string) : tree(dir.into([string])).process(
          Process.fromFun1R((t1) -> make.subtree(t,make.code(string,[t1])))
        );
        case Right(entry) : Attempt.pure(__.success(t.concat(make.datum(entry))));
      }
    }
    var ut  = Arrange.pure(Jali.unit());
    var d   = Arrange.bind_fold.bind(fn).fn().then( _ -> _.defv(ut));
    var e   = c.rearrange(d);
    var f = e.prefix(
      (env) -> __.couple(Jali.make().unit(),env)
    );
    //$type(a);
    // $type(b);
    //$type(c);
    // $type(fn);
    //$type(d);
    //$type(e);
    //$type(f);

    return Attempt.lift(f);
  }
}