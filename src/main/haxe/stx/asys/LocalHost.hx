package stx.asys;

@:forward abstract LocalHost(Device) from Device to Device{
  private function new(){
    this = Device.make0(new Distro());
  }
  static public function unit():LocalHost{
    return new LocalHost();
  }
}