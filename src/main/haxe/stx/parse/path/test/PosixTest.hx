package stx.parse.path.test;

class PosixTest extends TestCase{
  // public function test__p_root(async:Async){
  //   final input   = "/".reader();
  //   final parse   = new Posix().p_root();
    
  //   __.ctx(input,(x) -> { trace(x); async.done(); }).load(parse.toFletcher()).crunch();
  // }
  public function test__p_abs__p_root(){
    final input   = "/".reader();
    final parse   = new Posix().p_abs();
    
    __.ctx(input,(x) -> { trace(x); }).load(parse.toFletcher()).crunch();
  }
}