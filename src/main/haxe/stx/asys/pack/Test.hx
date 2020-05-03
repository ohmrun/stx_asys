package stx.asys.pack;

import utest.Assert in Rig;

import stx.asys.test.*;

class Test extends Clazz{
  public function deliver():Array<Dynamic>{
    return [
      new FsParseTest(),
      new AsysTest(),
      new DirDrillTest(),
    ].last().toArray();
  }
}
class DirDrillTest extends utest.Test{
  var dev = LocalHost.unit().toHasDevice();
  
  @Ignored
  public function test_cwd_crunch(async:utest.Async){
    var cwd = new Cwd();
        cwd.pop()
           .prepare(dev,
             (x) -> {
               trace(x);
               Rig.pass();
               async.done();
             }
          ).submit();

  }
  @Ignored
  public function test_cwd_submit(async:utest.Async){

    var cwd = new Cwd();
        cwd.pop()
           .prepare(dev,
              Sink.unit().stage(
                (x) -> {
                  Rig.pass();
                  async.done();
                  trace(x);
                },
                (_) -> {}
              )
           ).submit();
  }
  //@Ignored
  @:timout(6000)
  public function test(async:utest.Async){
    var cwd   = new Cwd();
    cwd.pop().reframe().arrange(
      Directory._.term
    ).evaluation()
     .prepare(__.success(LocalHost.unit().toHasDevice()),
      (x) -> {
        trace(x);
        async.done();
      }
     ).submit();
  }
}