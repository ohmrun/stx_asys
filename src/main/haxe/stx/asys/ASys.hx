package stx.asys;


interface ASysApi{
  public function local():HasDevice;
  public function sleep(float:Float):Future<Noise>;
  public function stderr():stx.io.Output;
  public function stdout():stx.io.Output;
  public function stdin():stx.io.Input;
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
  public function stderr():stx.io.Output{
    return new stx.io.Output(std.Sys.stderr());
  }
  public function stdout():stx.io.Output{
    return new stx.io.Output(std.Sys.stdout());
  }
  public function stdin():stx.io.Input{
    return stx.io.Input.make0(std.Sys.stdin());
  }
  public function local():HasDevice{
    return { device : new Device(new Distro()) };
  }
}