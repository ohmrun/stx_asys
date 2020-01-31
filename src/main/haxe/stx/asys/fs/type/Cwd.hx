package stx.asys.fs.head.data;

interface Cwd{
  public function pop():IO<String,FSFailure>;
  public function put(str:String):IO<Noise,FSFailure>;
}