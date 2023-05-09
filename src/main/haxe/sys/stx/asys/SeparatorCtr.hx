package sys.stx.asys;

class SeparatorCtr{
  static public function unit(tag:STX<Separator>){
    return new Separator(__.asys().Distro().unit());
  }
}