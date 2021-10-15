package stx.asys;


interface ASysApi{
  public function sleep(float:Float):Future<Noise>;
}

class ASys implements ASysApi{
  public function new(){}
  
  public function sleep(t):Future<Noise>{
    return Future.irreversible(
      (cb) -> {
        std.Sys.sleep(t);
        cb(Noise);
      }
    );
  }
  
}