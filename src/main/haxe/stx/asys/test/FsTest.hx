package stx.asys.test;

class FsTest extends TestCase{
  public function test_file_contents_error(){
    try{
      var env = __.asys().local();
          env.device.shell.cwd.pop().arrange(
            (dir:Directory) -> dir.entry('missing_file').val()
          ).environment(
            env,
            __.log().printer(),
            __.crack
          ).crunch();
    }catch(e:Rejection<Dynamic>){
      switch(e.data){
        case Some(ERR_OF(E_FileNotFound(arch))) : Rig.pass();
        default                                 : throw(e);
      }
    }
  }
}