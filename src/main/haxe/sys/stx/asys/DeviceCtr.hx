package sys.stx.asys;

class DeviceCtr{
  static public function unit(tag:STX<Device>){
    return Device.make0(__.asys().Distro().unit());
  }
}