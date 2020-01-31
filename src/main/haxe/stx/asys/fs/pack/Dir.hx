package stx.asys.fs.pack;

class Dir extends Clazz{
  var file = new stx.asys.fs.Package().file();
  public function new(){
    super();
  }
  public function insert(path:StdPath):IO<Bool,FSFailure>{
    var splitted  = path.toString().split(path.sep());
    var hierarchy = splitted.ds().lfold(
      (next:String,memo:Array<Array<String>>) -> return memo.snoc(
        memo.length == 0 ? [next].ds() : (memo[memo.length-1]).concat([]).snoc(next)
      ),
      [].ds()
    );
    var filtered = 
      IOs.bfold(
        (item:Array<String>,array:Array<Array<String>>) -> exists(item.join(path.sep())).fmap(
          (b:Bool) -> b.if_else(
            () -> IO.pure(array.cons(item)).errata(e -> e.fault().of(UnknownFSError)),
            () -> IO.pure(array).errata(e -> e.fault().of(UnknownFSError))
          )
        ),
        hierarchy.reversed(),
        [].ds()
      );
    var created = filtered.fmap(
      (arr) -> IOs.bfold(
        (item:Array<String>,b:Bool) -> 
          IOs.fromChunk(
            (() -> {
              FileSystem.createDirectory(item.join(path.sep()));
              return true;
            }).fn().catching().then(
              Chunks.fromOption
            )
          ).map(
            (_)-> true
          ).errata(
            e -> e.fault().of(UnknownFSError)
          ),
          arr,
          true
        )
    );
    return created;
  }  
  public function exists(str:String):IO<Bool,FSFailure>{
    return file.exists(str).fmap(
      (b0) -> file.is_dir(str).map((b1) -> b0 && b1)
    );
  }
  public function parent(str:String):IO<String,FSFailure>{
    return (() -> __.chunk(new StdPath(str).dir).map(
      (pth) -> StdPath.normalize(pth)
    ).fmap(
      (pth) -> {
        var arr = pth.split("/");
        var len = arr.length;
            arr.pop();
        return  len == 1 ? End(__.fault().of(IsNotADirectory)) : Val(arr.join("/"));
      } 
    )).broker(F -> IOs.fromChunkThunk);
  }
  public function index(path:StdPath):IO<Array<String>,FSFailure>{
    return FileSystem.readDirectory.bind(path.toString()).broker(
      F -> IOs.fromThunk
    ).errata(
      e -> e.fault().of(CannotReadDirectory)
    );
  }
}