package sys.stx.asys;

@:forward abstract LocalHost(DeviceApi) from DeviceApi to DeviceApi{
  private function new(){
    this = Device.make0(__.asys().Distro().unit());
  }
  static public function unit():LocalHost{
    return new LocalHost();
  }
}