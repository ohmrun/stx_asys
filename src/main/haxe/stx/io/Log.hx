package stx.io;

class Log{
  static public function log(wildcard:Wildcard):stx.Log{
    return stx.Log.ZERO.tag("stx.io");
  }
}