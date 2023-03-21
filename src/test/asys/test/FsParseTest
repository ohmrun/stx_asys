package stx.asys.test;

using stx.Ds;

function id(str){
  return __.parse().id(str);
}
class FsParseTest extends TestCase{
  var p     = new Posix();

  var p_root = "/";
  public function test_p_root(){
    var reader = p_root.reader();
    var parser = p.p_root();
    var result = parser.provide(reader).fudge();
    same([FPTDrive(None)],result.fudge());
  }
  function test_p_term(){
    var reader = 'abac'.reader();
    var parser = id('x').not()._and(Parser.Something()).many().tokenize(); 
    var result = parser.provide(reader).fudge();
    same("abac",result.fudge());
  }
  var p_rel_root = './';
  function test_p_rel_root(){
    var reader = p_rel_root.reader();
    var parser = p.p_rel_root();
    var result = parser.provide(reader).fudge();
    trace(result);
    //same("abac",result.fudge());
  }
  var not_p_rel_root = "..";

  // TODO stx_test needs `raises`
  // public function test_not_p_rel_root(){
  //   raises(
  //     () -> {
  //       p.p_rel_root().provide(not_p_rel_root.reader()).fudge().fudge();
  //     }
  //   );
  //   //__.log().debug(o);
  // }
  var up            : String = "..";
  public function test_up(){
    var o = p.provide(up.reader()).fudge();
    __.log().debug(_ -> _.pure(o));
    res(o);
  }
  var current       : String = ".";
  
  public function test_current(){
    var o = p.provide(current.reader()).fudge();
    __.log().debug(_ -> _.pure(o));
    same([FPTRel],o.value().fudge());
    res(o);
  }
  var ok_simple     : String = "/a/b/c";
  @:timeout(-1)
  public function test_simple(async:Async){
    var o = p.p_abs().provide(ok_simple.reader());
        o.environment(
          (o) -> {
            trace(o);
            async.done();
          }
        ).submit();
  }
  var ok_issue   : String = "./c";

  @:timeout(-1)
  public function testIssue(async:Async){
    var o = p.p_rel().and(Parser.Eof()).provide(ok_issue.reader());
    o.environment(
      (o) -> {
        trace(o);
        async.done();
      }
    ).submit();
  }

  var ok_relative   : String = "../../a/b/c";

  @:timeout(1000000)
  public function testSimpleRelative(async:Async){
    var o = p.p_rel().and(Parser.Eof()).provide(ok_relative.reader());
    o.environment(
      (o) -> {
        trace(o);
        async.done();
      }
    ).submit();
  }
  var ok_file       : String = "./odd.thing/test.txt";

  public function testSimpleFile(){
    var o = p.provide(ok_file.reader()).fudge();
    __.log().debug(_ -> _.pure(o));
    res(o);
  }

  public function testFileExt(){
    var o = p.provide(ok_file_no_ext.reader()).fudge();
    res(o);
  }

  var ok_abs        : String = "/a/b/c/";
  @:timeout(-1)
  public function test_abs(async:Async){
    var o = p.p_abs().provide(ok_abs.reader()).environment(
      __.log().printer().fn().then(
        Fn._0x(async.done.bind()).promote()
      )
    );
    o.submit();
  }

  public function testDotFolder(){
    var o = p.provide(ok_dot_folder.reader()).fudge();
    res(o);
  }

  public function testJustDown(){
    var o = p.provide(q_just_down.reader()).fudge();
    res(o);
  }

  public function testCompile(){
    var o = p.provide(ok_compile.reader()).fudge();
  } 

  public function testDownDown(){
    var o = p.provide(q_down_down.reader()).fudge();
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
  var ok_dot_folder : String = "/.cache/something";
  var q_just_down   : String = "down";
  var ok_compile    : String = "./something/../../wot.g/.cache/everything.txt";
  var q_down_down   : String = "down/down";
} 