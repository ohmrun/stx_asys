package stx.io.test;

import stx.fail.ProcessFailure;

using stx.Parse;
import stx.io.Process;
import haxe.io.Bytes;

class ProcessTest extends TestCase{
  // public function test_bytes_bounds_behaviour(){
  //  final target = Bytes.alloc(1);
  //  this.raises(target.fill.bind(1,2,5678));
  // }
  public function test_unit_processor(async:Async){
    final proc = Process.make0(['haxe',"--help"]);
    final read = Processor.make(
      proc,
      InputParser.unit(),
      InputParser.unit().map_r(
        (parse_result:ParseResult<InputResponse,Bytes>) -> parse_result.map(
          bytes   -> E_Process_Raw(bytes)
        )
      ),
      (num_calls,?last_timestamp) -> None
    ).toOutlet();
    __.ctx(
        Noise,
        (ok) -> {
          trace(ok);
          async.done();
        },
        no -> {
          trace(no);
          async.done();
        }
      ).load(
      read.action(x -> trace($type(x.toString()))).toExecute()
    ).submit();
  }
}