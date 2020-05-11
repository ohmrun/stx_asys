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
           .environment(dev,
             (x) -> {
               trace(x);
               Rig.pass();
               async.done();
             },
             __.raise
          ).submit();

  }
  @Ignored
  public function test_cwd_submit(async:utest.Async){

    var cwd = new Cwd();
        cwd.pop()
           .environment(
             dev,
             (x) -> {
              Rig.pass();
              async.done();
              trace(x);
            },
            __.raise
           ).submit();
  }
  //@Ignored
  @:timout(6000)
  public function test(async:utest.Async){
    var cwd 	= new Cwd();
		var host 	= LocalHost.unit().toHasDevice();
    cwd.pop()
      .process((dir:Directory) -> dir.into(['src', 'main', 'haxe', 'stx', 'fs']))
      .reframe()
      .arrange(
        Directory._.tree
      ).evaluation()
       .environment(
         host,
        (x) -> {
          trace(x);
        },
        __.raise
     ).submit();
     //crunch
  }
}