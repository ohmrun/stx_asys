package stx.asys.type;

interface Shell{
  public function print(v:Dynamic):Bang;
  public function println(v:Dynamic):Bang;

  public function stdin():StdIn;
  public function stderr():StdOut;
  public function stdout():StdOut;

  public function byte():Proceed<Int,ASysFailure>;
  
  public var cwd(default,null):Cwd;
  
  //public function command
  //public var env(default,null)        : Env;
}