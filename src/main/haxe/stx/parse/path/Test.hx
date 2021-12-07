package stx.parse.path;

import stx.parse.path.test.*;
import stx.parse.path.test.issues.*;

using stx.Test;
using stx.Log;

class Test{
  static public function main(){
    final log = __.log().global;
          log.includes.push("stx/fs/path");
          log.includes.push("stx/parse");
          log.includes.push("stx/parse/path");
          log.includes.push("stx/parse/parser/With");
    __.test(
      [
        new PosixTest(),
        //new Issue1(),
      ],
      []
    );
  }
}