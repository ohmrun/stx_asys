package stx.asys.core.pack;

class Sys{
  static public function sleep(t):Block{
    return () -> Sys.sleep(t);
  }
}