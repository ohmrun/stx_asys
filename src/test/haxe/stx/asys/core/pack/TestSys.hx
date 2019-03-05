package stx.asys.core.pack;

import utest.Assert;
import stx.asys.core.Package.Sys;
import haxe.Timer;

class TestSys implements utest.ITest{
  public function new(){}
  function testSleep(){
    var t = Timer.stamp();
    var time = 0.5;
    Sys.sleep().tapR(
      (ret)-> {
        var u = Timer.stamp();
        Assert.isTrue(u-t > time);
      }
    ).provide(time);
  }
}