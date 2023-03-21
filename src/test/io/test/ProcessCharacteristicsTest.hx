package stx.io.test;


/**
  Errors
  Invalid string
**/
class ProcessCharacteristicsTest extends TestCase{
  public function test_receding_eof(){
    final process = new sys.io.Process("character_printer");
    while(true){
      trace("\n");
      //std.Sys.sleep(2);
      try{
        trace(process.stdout.readByte());
      }catch(e:haxe.Exception){
        trace(e.details());
      }
      
      trace("\n");
    }
  }
}