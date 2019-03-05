package stx.asys.fs.head.data;

interface Directory{
  //public function set(obj:{path:Path, ?modes:Modes}):Future<Maybe<Error>>;
  //public function rem(path:Path):Future<Error>;
  public function readdir(path:Path):Promise<Array<String>>;
}
