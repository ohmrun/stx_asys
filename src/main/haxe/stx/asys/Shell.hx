package stx.asys;

interface ShellApi{
  public function print(v:Dynamic):Future<Noise>;
  public function println(v:Dynamic):Future<Noise>;

  public function stdin():Input;
  public function stderr():Output;
  public function stdout():Output;

  
  public var cwd(default,null):Cwd;
  
  //public function command
  //public var env(default,null)        : Env;
}

class Shell implements ShellApi extends Clazz{
  static public function unit(){
    return new Shell();
  }
  public function new(){
    super();
    cwd = new Cwd();
  }
  public var cwd(default,null):Cwd;

  public function print(v:Dynamic):Future<Noise>{
    return Future.irreversible(cb -> {std.Sys.print(v);cb(Noise);});
  }  
  public function println(v:Dynamic):Future<Noise>{
    return Future.irreversible(cb -> {std.Sys.println(v);cb(Noise);});
  }  
  public function stdin(){
    return new Input(new StdIn(std.Sys.stdin()));
  }
  public function stdout(){
    return new Output(new StdOut(std.Sys.stdout()));
  }
  public function stderr(){
    return new Output(new StdOut(std.Sys.stderr()));
  }
  // public function char():Produce<Int>{
  //   return () -> Sys.getChar(false);
  // }

  public function byte():Produce<Int,ASysFailure>{
    return Produce.fromFunXR(std.Sys.getChar.bind(false));
  }
}