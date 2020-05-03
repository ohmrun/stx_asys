package stx.asys.pack;

@:forward abstract LocalHost(Device) from Device to Device{
  private function new(){
    this = new Device(new Distro());
  }
  static public function unit():LocalHost{
    return new LocalHost();
  }
}