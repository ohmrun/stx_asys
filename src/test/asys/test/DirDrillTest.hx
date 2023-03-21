package stx.asys.test;

class DirDrillTest extends TestCase{
  var dev = LocalHost.unit().toHasDevice();
  
  @:timeout(100000)
  public function _test_cwd_crunch(async:Async){
    var cwd = new Cwd();
        cwd.pop()
           .environment(dev,
             (x) -> {
               trace(x);
               pass();
               async.done();
             },
             __.crack
          ).submit();

  }
  @:timeout(100000)
  public function _test_cwd_submit(async:Async){
    __.log().debug('test_cwd_submit');
    var cwd = new Cwd();
        cwd.pop()
           .environment(
             dev,
             (x) -> {
              trace(x);
              pass();
              async.done();
            },
            __.crack
           ).submit();
  }
  @:timeout(100000)
  public function test(async:Async){
    __.log().debug('tedst');
    var cwd 	= new Cwd();
		var host 	= LocalHost.unit().toHasDevice();
    cwd.pop()
      .convert(
        (dir:Directory) -> {
          trace(dir);
          return dir.into(['src', 'main', 'haxe', 'stx', 'fs']);
        }
      ).reframe()
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
     ).submit();
     //crunch
  }
}