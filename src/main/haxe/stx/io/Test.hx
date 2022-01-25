package stx.io;



using stx.Nano;
using stx.Log;
using stx.Test;

import stx.io.test.*;

class Test{
  static function main(){
    trace('stx.io.Test');
    var log       = __.log().global;
        log.level = DEBUG;
        log.includes.push("stx/io");
    __.log().info('stx.io::Test');
    __.test([
      new ProcessTest()
    ],[]);
  }
}