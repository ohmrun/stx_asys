package stx.io.test;

import stx.fail.ProcessFailure;

using stx.Parse;
import stx.io.Process;
import haxe.io.Bytes;

import stx.io.processor.term.Unit;

class ProcessTest extends TestCase{
  // public function test_bytes_bounds_behaviour(){
  //  final target = Bytes.alloc(1);
  //  this.raises(target.fill.bind(1,2,5678));
  // }
  public function test_unit_processor(async:Async){
    final process     = Process.make0(['echo',"'hello'"]);
    final processor   = new Unit(process);
    final proxy       = processor.reply().toOutlet();
          proxy.pledge().handle(
            x -> {
              trace(x);
              async.done();
            }
          );
  }
}