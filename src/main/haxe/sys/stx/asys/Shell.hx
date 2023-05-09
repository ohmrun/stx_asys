package sys.stx.asys;

class Shell implements ShellApi extends Clazz{
  static public function unit(){
    return new Shell();
  }
  public function new(){
    super();
    cwd = new Cwd();
  }
  public final cwd:Cwd;
  
  public function stdin(){
    return Input.make0(new StdIn(std.Sys.stdin()));
  }
  public function stdout(){
    return new Output(new StdOut(std.Sys.stdout()));
  }
  public function stderr(){
    return new Output(new StdOut(std.Sys.stderr()));
  }
  public function byte():Produce<Int,IoFailure>{
    return Produce.fromFunXR(std.Sys.getChar.bind(false));
  }
}