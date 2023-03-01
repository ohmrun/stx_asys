package stx.asys;

using stx.Test;

class Test{
  static public function main(){
    var f = __.log().global;
    var l = Log._.Logic();
        l.pack('stx/fs/path/Directory')
        //.pack('stx/parse/path');
        .pack('stx/asys/test')
        .pack('stx.fs.Path')
        //.pack('stx/async');
        //.pack('stx/parse');
        //.pack('stx.parse.With');
        .level(TRACE);

    __.test().run([
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