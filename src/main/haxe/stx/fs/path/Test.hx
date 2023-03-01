package stx.fs.path;

using stx.Test;
//using stx.Bake;

class Test{
  static public function main(){
    final log = __.log().global;
    final flt = Log._.Logic()
      .pack("eu/ohmrun/fletcher")
      .pack("**/*")
      .level(TRACE);

    __.test().run(
      [new DirectoryTest()],
      []
    );
  }
}
class ParseTest extends TestCase{
   
}
class DirectoryTest extends TestCase{
  public function test_inject(async:Async){
    final bake    = __.bake();
    final state   = __.asys().local();
    final dir     = Directory.parse(__.bake().get_build_directory().fudge()).map((x:Directory) -> x.into(["test","a","b"])).errate(e -> (e:FsFailure));
    final inject  = dir.reframe().commandment(Directory._.inject).evaluation();
    __.ctx(
      __.accept(state),
      (x) -> {
        accepted(x);
        async.done();
      }
    ).load(inject.toFletcher())
     .submit();
  }
  public function test_search_ancestors(async:Async){
    
  }
}