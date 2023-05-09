package sys.stx.asys;


class DistroCtr{
  static public function unit(tag:STX<stx.asys.Distro>){
    return new Distro(std.Sys.systemName());
  }
}