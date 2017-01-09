package;

using stx.async.Arrowlet;
import stx.proxy.data.Proxy;
import stx.io.Peck;
import stx.io.proxy.Process;

using Lambda;

class Test{
  static function main(){
    new Test();
  }
  public function new(){
    var runner = new utest.Runner();
    var tests : Array<Dynamic> = [
      new ProcessTest(),
      //new asys.FilePathTest(),
      /*
      #if nodehx
        new asys.nodejs.FsTest(),
        new asys.nodejs.BufferTest(),
      #end
      */
    ];
    utest.ui.Report.create(runner);
    tests.iter(
      function(x){
        runner.addCase(x);
      }
    );
    runner.run();
  }
}
class ProcessTest{
  public function new(){}
  public function test(){
    var a = Process.apply("echo",["BOOO!"])(Pull(LINE));
    handler(a);
  }
  function handler(v){
    trace(v);
    switch(v){
      case Yield(x,fn)  : trace(x); fn(Pull(LINE),handler);
      case Ended(e)     : trace(e);
      default :
    }
  }
}
