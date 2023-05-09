package sys.stx.asys;

@:forward abstract LocalHost(DeviceApi) from DeviceApi to DeviceApi{
  private function new(){
    this = Device.make0(new Distro());
  }
  static public function unit():LocalHost{
    return new LocalHost();
  }
}