package stx.asys.test;

class AsysTest extends TestCase{
  var local = Device.local();
  @Ignored
  public function testA(async:Async){
    Produce.pure(std.Sys.getCwd());
    
    // __.channel().io(__.into2(Paths._.toDirectory)).toChannel().prepare(
    //   __.accept(Devices.local()),
    //   Strand.unit()
    // ).crunch();
    //var get_path  = __.asys().path(Sys.getCwd()).fudge(local);
    //trace(get_path);
  }
  @Ignored
  public function testB(async:Async){
    Path.parse(std.Sys.getCwd())
        .reframe();
        //.forward(local)
        //.submit();
  }
  @Ignored
  public function test(){
    trace(std.Sys.getCwd());
    var path        = __.asys().local().device.shell.cwd.pop();
    //var next        = path.receive(Devices.local());   
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
    var next = path.convert(
      (dir:Directory) -> dir.into(['testing'])
    ).reframe()
     .commandment(Directory._.inject);

    //next.evaluation().prepare(__.accept(local),Automation.unit()).crunch();

  }
}