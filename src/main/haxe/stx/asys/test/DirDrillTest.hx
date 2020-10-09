package stx.asys.test;

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
             __.crack
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
            __.crack
           ).submit();
  }
  //@Ignored
  @:timeout(30000)
  public function test(async:utest.Async){
    var cwd 	= new Cwd();
		var host 	= LocalHost.unit().toHasDevice();
    cwd.pop()
      .convert((dir:Directory) -> dir.into(['src', 'main', 'haxe', 'stx', 'fs']))
      .reframe()
      .arrange(
        Directory._.tree
      ).evaluation()
       .environment(
         host,
        (x) -> {
          trace(
            x.toString_with((entry:Entry) -> entry.toString())
          );
          async.done();
        },
        (e) -> {
          trace(e);
        }
     ).crunch();
     //crunch
  }
}