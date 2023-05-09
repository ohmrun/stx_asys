package sys.stx.asys;

class Console implements ConsoleApi{
  public function print(v:Dynamic):Future<Noise>{
    return Future.irreversible(cb -> {std.Sys.print(v);cb(Noise);});
  }  
  public function println(v:Dynamic):Future<Noise>{
    return Future.irreversible(cb -> {std.Sys.println(v);cb(Noise);});
  }  
}