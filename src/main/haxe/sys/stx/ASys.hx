package sys.stx;

import stx.Fs;

class ASys{
  static public function Distro(module:stx.asys.Module):STX<stx.asys.Distro>{
    return STX;
  }
  static public function Separator(module:stx.asys.Module):STX<Separator>{
    return STX;
  }
}
typedef DistroCtr     = sys.stx.asys.DistroCtr;
typedef DeviceCtr     = sys.stx.asys.DeviceCtr;
typedef SeparatorCtr  = sys.stx.asys.SeparatorCtr;
/**
 * 
 * __.asys().Distro().unit()
 */
