package stx.io.test;

import haxe.io.*;

import sys.io.Process;
import stx.io.pack.Process;

class ProcessTest extends utest.Test{
  var log : Log = __.log();
  public function test(){
    var p   = new StdProcess("",[]);
    var out = p.stdout;
    var b0  = out.read(0);
    var sb  = out.readAll();
    var s   = sb.toString();
    log.trace('"$s"');
    var bytes = new BytesBuffer().getBytes();
    var err = p.stderr;
    Assert.raises(
      ()->{
        var e0  = err.readBytes(bytes,0,1);
      }
    );
    var eb  = err.readAll();
    var e   = eb.toString();
    log.trace('"$e"');
  }
}