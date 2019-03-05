package stx.asys.io;

typedef Buffer  = stx.asys.io.pack.Buffer;
typedef Cwd     = stx.asys.io.pack.Cwd;
typedef Input   = stx.asys.io.pack.Input;
typedef Output  = stx.asys.io.pack.Output;
typedef Path    = stx.asys.io.pack.Path;

class Package{
  static public function input(ipt:haxe.io.Input):Pipe<Peck,Iota>{
    return Input.apply(ipt);
  }
  static public function output(opt:haxe.io.Output):Sink<Value>{
    return Output.apply(opt);
  }
}