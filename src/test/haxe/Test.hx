package;

import stx.simplex.Package;
using Lambda;

class Test{
  static function main(){
    new Test();
  }
  public function new(){
    var runner = new utest.Runner();
    var tests : Array<Dynamic> = [
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
    runner.run();
  }
}
class ThreadTest{
  public function new(){}
}
typedef RemoteThread<I> = Emiter<I>;

class RemoteThreads{
  static public function create<I>(){
    var incremental_backoff = 0.2;
    var stack               = [];
    
    var thread = neko.vm.Thread.create(
      () -> {
        var message = neko.vm.Thread.readMessage(false);
        if(message == null){

        }
      }
    );
    return Wait(
      (i:I) -> 
    )
  }
}
/*
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
*/