package;

import tink.core.Future;
import stx.fn.Package;
import stx.core.Package;
import tink.core.Noise;
import stx.simplex.core.Package;
import stx.simplex.Package;


using Lambda;

class Test{
  static function main(){
    new Test();
  }
  public function new(){
    var runner = new utest.Runner();
    var tests : Array<Dynamic> = [
      new stx.asys.core.pack.TestSys(),
      new stx.asys.TestIO(),
      //new BackoffTest(),
      //new ProcessTest(),
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
    trace("start");
    Sys.sleep(1);
    runner.run();
    trace("end");
  }
}