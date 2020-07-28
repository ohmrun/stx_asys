package stx.asys.test;

using stx.Ds;

class FsParseTest extends utest.Test{
  var log   = __.log();
  var p     = new Posix();

  var up            : String = "..";
  public function test(){
    var o = p.forward(up.reader()).fudge();
    //log(o);
    res(o);
  }
  var current       : String = ".";
  public function testCurrent(){
    var o = p.forward(current.reader()).fudge();
    //log(o);
    res(o);
  }
  var ok_simple     : String = "/a/b/c";
  public function testSimple(){
    var o = p.forward(ok_simple.reader()).fudge();
    //log(o);
    res(o);
  }
  var ok_relative   : String = "../../a/b/c";
  public function testSimpleRelative(){
    var o = p.forward(ok_relative.reader()).fudge();
    //log(o);
    res(o);
  }
  var ok_file       : String = "./odd.thing/test.txt";
  public function testSimpleFile(){
    var o = p.forward(ok_file.reader()).fudge();
    log(o);
    res(o);
  }
  public function testFileExt(){
    var o = p.forward(ok_file_no_ext.reader()).fudge();
    res(o);
  }
  public function testDir(){
    var o = p.forward(ok_dir.reader()).fudge();
    res(o);
  }
  public function testDotFolder(){
    var o = p.forward(ok_dot_folder.reader()).fudge();
    res(o);
  }
  public function testJustDown(){
    var o = p.forward(q_just_down.reader()).fudge();
    res(o);
  }
  public function testCompile(){
    var o = p.forward(ok_compile.reader()).fudge();
  } 
  public function testDownDown(){
    var o = p.forward(q_down_down.reader()).fudge();
    res(o);
  }
  function res(o:ParseResult<Dynamic,Dynamic>){
    o.fold(
      (_) -> {},
      (e) -> throw(e)
    );
  }
  function resF(o:ParseResult<Dynamic,Dynamic>){
    o.fold(
      (s) -> throw(s),
      (e) -> {}
    );
  }
  /*override function tests(){
		return __.option(
      Field.create(
        "FsParseTest",
        [
          "testDir" => testDir.fn() 
        ].ds()
      )  
    );
	}*/
  

  
  var no_not_dot    : String = "."; 
  
  var ok_file_no_ext: String = "/a/b/c";
  var ok_dir        : String = "/a/b/c/";
  var ok_dot_folder : String = "/.cache/something";
  var q_just_down   : String = "down";
  var ok_compile    : String = "./something/../../wot.g/.cache/everything.txt";
  var q_down_down   : String = "down/down";
}