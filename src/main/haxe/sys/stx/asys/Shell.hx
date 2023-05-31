package sys.stx.asys;

class Shell implements ShellApi extends Clazz{
  static public function unit(){
    return new Shell();
  }
  public final env : EnvApi;
  
  public function new(){
    super();
    this.cwd = new Cwd();
    this.env = new sys.stx.asys.Env();
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
  public function byte():Future<Int>{
    return Future.lazy(std.Sys.getChar.bind(false));
  }
}