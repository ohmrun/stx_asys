package stx.asys;

using stx.Test;

class Test{
  static public function main(){
    var f = __.log().global;
        f.includes.push('stx.fs.path.pack.Directory');
        //f.includes.push('stx.parse.path');
        f.includes.push('stx/asys/test');
        f.includes.push('stx.fs.Path');
        //f.includes.push('stx.async');
        //f.includes.push('stx.parse');
        //f.includes.push('stx.parse.With');
        f.reinstate  = true;

        f.level = TRACE;
    __.test([
      // new FsParseTest(),
      // new AsysTest(),
      // new SocketTest(),
      // new DirDrillTest(),
      // new ArchiveTest(),
      // new EnvTest(),
      // new FsTest(),
      // new EmptyTest(),
    ],[]);
  }
}
class EmptyTest extends TestCase{
  public function test(){
    pass();
  }
}
class EnvTest extends TestCase{
  public function test_get(){
    var env    = __.asys().local().device.env;
    var path   = env.get("UNKNOWN");
        __.ctx(Noise).load(path).crunch();
  }
}
class SocketTest extends TestCase{
  public function test(){
    var input   = Shell.unit().stdin();
    //var proxy = input(IReqValue(ByteSize.LINE));
  }
}