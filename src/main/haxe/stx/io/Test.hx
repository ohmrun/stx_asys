package stx.io;



using stx.Nano;
using stx.Log;
using stx.Test;

import stx.io.test.*;

class Test{
  static public function tests(){
    return [
      new ProcessCharacteristicsTest()
    ];
  }
  static function main(){
    trace('stx.io.Test');
    var log       = __.log().global;
    var ic        = Log._.Logic()
        .level(DEBUG)
        .pack("stx/io");
    __.log().info('stx.io::Test');
    __.test().auto();
  }
}