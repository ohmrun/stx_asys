package stx.asys.test;

class AsysTest extends utest.Test{
  var local = Devices.local();
  @Ignored
  public function testA(async:utest.Async){
    Proceed.pure(Sys.getCwd());
    
    // __.channel().io(__.into2(Paths._.toDirectory)).toChannel().prepare(
    //   __.success(Devices.local()),
    //   Strand.unit()
    // ).crunch();
    //var get_path  = __.asys().path(Sys.getCwd()).fudge(local);
    //trace(get_path);
  }
  @Ignored
  public function testB(async:utest.Async){
    Path.parse(Sys.getCwd())
        .reframe();
        //.forward(local)
        //.submit();
  }
  @Ignored
  public function test(){
    trace(Sys.getCwd());
    var path        = __.asys().local().device.shell.cwd.pop();
    var next        = path.receive(Devices.local());   
     //     path.deliver(
    //       (x) -> Assert.pass()
    //     ).crunch();
  }
  @Ignored
  public function testDirInsert(){
    var dir = Directory.make(None,"mnt.dat.prj.haxe.stx_asys.test".split("."));
    //Directory._.inject(dir).prepare(local,Automation.unit()).crunch();
  }
  
  public function testDir(){
    var path = __.asys().local().device.shell.cwd.pop();
    var next = path.process(
      (dir:Directory) -> dir.into(['testing'])
    ).reframe()
     .commander(Directory._.inject);

    //next.evaluation().prepare(__.success(local),Automation.unit()).crunch();

  }
}