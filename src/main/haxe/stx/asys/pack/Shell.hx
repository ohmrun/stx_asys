package stx.asys.pack;

class Shell implements stx.asys.type.Shell extends Clazz{
  public function new(){
    super();
    cwd = new Cwd();
  }
  public var cwd(default,null):Cwd;

  public function print(v:Dynamic):Bang{
    return Bang.pure(Sys.print.bind(v));
  }  
  public function println(v:Dynamic):Bang{
    return Bang.pure(Sys.println.bind(v));
  }  
  public function stdin(){
    return new StdIn(Sys.stdin());
  }
  public function stdout(){
    return new StdOut(Sys.stdout());
  }
  public function stderr(){
    return new StdOut(Sys.stderr());
  }

  public function byte():Proceed<Int,ASysFailure>{
    return Proceed.fromFunXR(Sys.getChar.bind(false));
  }
}