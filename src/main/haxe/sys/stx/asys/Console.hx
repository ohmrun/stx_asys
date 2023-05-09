package sys.stx.asys;

class Console implements ConsoleApi extends Clazz{
  public function print(v:Dynamic):Future<Nada>{
    return Future.irreversible(cb -> {std.Sys.print(v);cb(Nada);});
  }  
  public function println(v:Dynamic):Future<Nada>{
    return Future.irreversible(cb -> {std.Sys.println(v);cb(Nada);});
  }  
}