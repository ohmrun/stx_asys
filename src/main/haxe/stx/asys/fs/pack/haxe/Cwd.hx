package stx.asys.fs.pack.haxe;

import stx.asys.fs.head.data.Cwd in CwdI;

class Cwd implements CwdI{
  public function new(){}
  public function pop():Future<String>{
    return Future.sync(Sys.getCwd());
  }
  public function put(str:String):Future<Null<Error>>{
    Sys.setCwd(str);
    return Future.sync(null);
  }
}
