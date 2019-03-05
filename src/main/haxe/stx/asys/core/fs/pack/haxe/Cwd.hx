package stx.asys.core.fs.pack.haxe;

import stx.asys.core.fs.head.data.Cwd in CwdI;

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
