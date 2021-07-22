package stx.asys.test;

class ArchiveTest extends TestCase{
  public function test_non_existent_get(){
    var arc : Archive = {
      drive : None,
      track : ["nope"],
      entry : "not.here"
    };

    __.ctx(__.asys().local()).load(
      arc.val()
    ).crunch();
  }
}