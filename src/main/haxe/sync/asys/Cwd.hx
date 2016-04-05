package sync.asys;

using tink.CoreApi;

import asys.ifs.Cwd in ICwd;

class Cwd implements ICwd{
  public function new(){

  }
  public function pop():Future<String>{
    return Future.sync(Sys.getCwd());
  }
  public function put(str:String):Future<Null<Error>>{
    Sys.setCwd(str);
    return Future.sync(null);
  }
}
