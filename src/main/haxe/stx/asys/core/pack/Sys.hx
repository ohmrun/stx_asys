package stx.asys.core.pack;

import stx.simplex.Package;

class Sys{
  static public function sleep(t):Block{
    return () -> Sys.sleep(t);
  }
}