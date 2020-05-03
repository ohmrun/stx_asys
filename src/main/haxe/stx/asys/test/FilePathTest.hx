package stx.asys.test;

using utest.Assert;
import utest.Assert;

class FilePathTest extends utest.Test{
  function wins(){
    return { device : new Device(Windows) };
  }
  function nixs(){
    return { device : new Device(Linux) };
  }
  //@Ignored
  public function testAbsWin(){
    var a  = "C:\\".filepath();
    var b  = null;
    try{
        b  = a.crunch(wins());
    }catch(e:FilePathError){ 
      for (err in e){
        switch(err) {
          case FilePathParseFailure(MalformedSource(Failure(err,xs,is_error))) :
            //trace(xs);
          default : 
        }
      }
    }
    Assert.isTrue(a.crunch(wins()).kind().absolute);
  }
 // @Ignored
  public function testWinsNotAbsolute0(){
    var a = ".\\something".filepath();
    
    Assert.isFalse(a.crunch(wins()).kind().absolute);
  }
  //????
  @Ignored
  public function testWinsNotAbsolute1(){
    var a = "\\something".filepath();
    var b = a.crunch(wins());
    
    //Assert.isFalse(a.kind().crunch(wins()).absolute);
  }
  //@Ignored
  public function testWinsNotAbsolute2(){ 
    var a = "other\\something".filepath();
    
    Assert.isFalse(a.crunch(wins()).kind().absolute);
  }
  //@Ignored
  public function testAbsPos(){
    var a = "/rootish".filepath();
    Assert.isTrue(a.crunch(nixs()).kind().absolute);
  
  }
  //@Ignored
  public function testIsDirectory(){
    var a = "C:\\win\\hope\\".filepath();
    var b = a.crunch(wins());
    trace(a);
    
    Assert.isTrue(a.crunch(wins()).kind().has_trailing_slash);
  
  }
  //@Ignored
  public function testIsDirectory0(){
    var a = "C:\\win\\hope".filepath();
    
    Assert.isFalse(a.crunch(wins()).kind().has_trailing_slash);
  }
  @Ignored
  public function testIsDirectory2(){
    var a = "C:\\win\\hope\\".filepath();
    
    Assert.isTrue(a.crunch(wins()).kind().has_trailing_slash);
  }
  //@Ignored
  public function testIsDirectory3(){
    var a = "posix/thing/".filepath();
    
    Assert.isTrue(a.crunch(nixs()).kind().has_trailing_slash);
  }
  //@Ignored
  public function testIsDirectory4(){
    var a = "posix/thing.ogg".filepath();
    
    Assert.isFalse(a.crunch(nixs()).kind().has_trailing_slash);
  }
  //@Ignored
  public function testIsDirectory1(){
    var a = "C:\\win\\hope\\".filepath();
    // trace(
    //   a.now(wins()).fold(
    //     (_) ->  None.core(),
    //     (e) ->  e.result(),
    //     ()  ->  None.core()
    //   ).flat_map(
    //     (x) -> x.head()
    //   ).flat_map(
    //     (x) -> switch(x){
    //       case Failure(e,rest,_) : Some(rest.content.at(rest.content.index));
    //       default : None;
    //     }
    //   )
    // );
    Assert.isTrue(a.crunch(wins()).kind().has_trailing_slash);
  }
  //@Ignored
  public function testFilename(){
    //var a       = '/path/to/file.wav'.filepath();
    //var b       = a.toReference().crunch(nixs());
    //Assert.equals('file.wav',b.tail.map((x)->'${x.name}.${x.ext}').defv(""));
  }
}