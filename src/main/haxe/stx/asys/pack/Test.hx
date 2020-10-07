package stx.asys.pack;

import stx.asys.test.*;

class Test extends Clazz{
  public function deliver():Array<Dynamic>{
    trace(
      "test"
    );
    return [
      new FsParseTest(),
      new AsysTest(),
      new SocketTest(),
      new DirDrillTest(),
      new ArchiveTest(),
      new EnvTest(),
      new FsTest()
    ];//.last().toArray();
  }
}

class EnvTest extends utest.Test{
  public function test_get(){
    var env    = __.asys().local().device.env;
    var path   = env.get("UNKNOWN");
        path.environment(
          __.log().printer(),
          __.log().printer()
        ).crunch();
  }
}
class SocketTest extends utest.Test{
  public function test(){
    var input = Shell.unit().stdin();
    var proxy = input(IReqValue(ByteSize.LINE));
  }
}
class ArchiveTest extends utest.Test{
  public function test_non_existent_get(){
    var arc : Archive = {
      drive : None,
      track : ["nope"],
      entry : "not.here"
    };
    arc.val().environment(
      __.asys().local(),
      __.log().printer(),
      __.crack
    ).crunch();
  }
}