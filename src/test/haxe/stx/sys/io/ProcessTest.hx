package stx.sys.io;

using stx.async.Arrowlet;

import stx.Tuple.Tuples2.snd;
using stx.Tuple;


using stx.Proxy;
import stx.proxy.data.Proxy;

import stx.sys.io.Process;

class ProcessTest{
  public function new(){}

  public function testProc(){
     var a = Process.create("tree");
     var b : ProcessProxy = a(Pull(LINE));

     var c = a.toArrowlet();

     var p = null;
     var d = c.pulling(
       p = function(v){
         trace(v);
         return Await(Pull(LINE),p);
       }
     );
  }
}
