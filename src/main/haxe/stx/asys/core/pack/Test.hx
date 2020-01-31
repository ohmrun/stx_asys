package stx.asys.core.pack;

class Test extends Clazz{
  public function deliver():Array<{}>{
    return [
      new WhereYourGrilsAtTest()
    ];
  }
}
class WhereYourGrilsAtTest extends utest.Test{
  static var sys = __.asys().local();
  //@Ignored
  public function testPushBackBecauseThatsTheCoolestThingObviously(){
    sys.byte()(Automation.unit())(
      (v) -> {
        Assert.pass();
      }
    ).crunch();

    //Sys.stdout().writeByte("t".core().char(0).code());
    //Sys.stdout().close();
  }
  public function testPushBackUntilEnter(){
    var a = sys.byte();
    var b = Sources.fromUIO(a);
        //b.
  }
}