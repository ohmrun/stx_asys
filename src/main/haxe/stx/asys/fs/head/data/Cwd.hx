package stx.asys.fs.head.data;

interface Cwd{
  public function pop():Vouch<String,FSFailure>;
  public function put(str:String):Vouch<Noise,FSFailure>;
}
