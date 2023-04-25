package stx.fs.path;

import stx.fail.FsFailure;
using stx.Nano;
using stx.Test;
using stx.Log;
using stx.ASys;
using eu.ohmrun.Fletcher;
//using Bake;

class Test{
  static public function main(){
    __.logger().global().configure(
      logger -> logger.with_logic(
        logic -> logic.or(
          logic.tags([
            "eu/ohmrun/fletcher",
            "**/*"
          ])
        )
      )
    );
    __.test().run(
      [new DirectoryTest()],
      []
    );
  }
}
class ParseTest extends TestCase{
   
}
@stx.test.async
class DirectoryTest extends TestCase{
  public function test_inject(async:Async){
    final bake    = Bake.pop();
    final state   = __.asys().local();
    trace(bake);
    final bdir    = (bake.get_build_directory():stx.pico.Option<String>).or(() -> __.option(Sys.getEnv("PRJ_DIR")));
    trace(bdir);
    final dir     = Directory.parse(bdir.fudge()).map((x:Directory) -> x.into(["test","a","b"])).errate(e -> (e:FsFailure));
    final inject  = dir.reframe().commandment(Directory._.inject).evaluation();
    inject.environment(
      state,
      (x) -> {
        accepted(x);
        async.done();
      }
    ).submit();
  }
  // public function test_search_ancestors(async:Async){
  //   async.done()   
  // }
}