package stx.asys.fs.head.data;

interface Cwd{
  public function pop():Future<String>;
  public function put(str:String):Future<Null<Error>>;
}
