package sys.stx.fs;

class Directories{
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
  static public function tree(dir:Directory):Modulate<HasDevice,PExpr<Entry>,FsFailure>{
    __.log().trace('tree: $dir');
    var init  = Arrange.fromFun1Attempt(entries);
    var c     = (Modulate.pure(dir).reframe().arrange(entries)).map(x -> x.toIter());
    
    function fn(either:Either<String,Entry>,t:PExpr<Entry>):Modulate<HasDevice,PExpr<Entry>,FsFailure>{
      __.log().trace(_ -> _.pure(either));
      return switch(either){
        case Left(string) : 
          var into = dir.into([string]);
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
          rest;
          //$type(rest);
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
}