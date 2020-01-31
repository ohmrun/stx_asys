package stx.asys.pack;


class ASys implements stx.asys.type.ASys{
  public function new(){}
  public function sleep(t):UIO<Noise>{
    return UIOs.fromThunk(
      () -> {
        Sys.sleep(t);
        return Noise;
      }
    );
  }
  public function byte():UIO<Int>{
    return UIOs.fromThunk(Sys.getChar.bind(true));
  }

  @:isVar public var device(get,null) : Device;
  private function get_device():Device{
    return __.option(this.device).is_defined().if_else(
      () -> this.device,
      () -> this.device = new Device(new Distro())
    );
  }
  
}