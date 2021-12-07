package stx.parse.path.test;

class PosixTest extends TestCase{
  private var parser = new Posix();
  private function on_done<T,S>(x:ParseResult<T,S>,?fn:Void->Void){
    trace('$x');
    if(fn!=null){
      fn();
    }
  }
  // public function test__p_root(async:Async){
  //   final input   = "/".reader();
  //   final parse   = new Posix().p_root();
    
  //   __.ctx(input,(x) -> { trace(x); async.done(); }).load(parse.toFletcher()).crunch();
  // }
  public function __test__p_abs__p_root(){
    final input   = "/".reader();
    final parse   = new Posix().p_abs();
    
    __.ctx(input,(x) -> { trace(x); }).load(parse.toFletcher()).crunch();
  }
  public function _test__char_and_space(){
    final input = "a".reader();
    final parse = parser.char_and_space;
    __.ctx(input,on_done.bind(_,()->{})).load(parse).crunch();
  }
  public function test__one_many_char_and_space(){
    final input = "aaa".reader();
    final parse = parser.char_and_space.one_many().tokenize();
    __.ctx(input,on_done.bind(_,()->{})).load(parse).crunch();
  }
  public function _test__p_down(){           
    final input = "abc".reader();
    final parse = parser.p_path_chars();
    __.ctx(input,on_done.bind(_,()->{})).load(parse).crunch();
  }
}