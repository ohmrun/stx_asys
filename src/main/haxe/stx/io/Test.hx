package stx.io;

using stx.Nano;
using stx.Log;
using stx.Test;

import stx.io.test.*;

class Test{
  static function main(){
    __.test([
      new ProcessTest()
    ],[]);
  }
}