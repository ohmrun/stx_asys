package stx.asys.core.pack;

import stx.asys.core.head.data.Device;

class ASys{
  static public function sleep(t):Block{
    return () -> Sys.sleep(t);
  }
  static public function device():Device{
    return new Local();
  }
}