package stx.asys.pack;

class ASys implements stx.asys.type.ASys{
  public function new(){}
  
  public function sleep(t):Bang{
    return Bang.pure(
      Sys.sleep.bind(t)
    );
  }
}