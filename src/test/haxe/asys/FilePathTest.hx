package asys;

import utest.Assert.*;

class FilePathTest{
  public function new(){
    
  }
  public function testAbs(){
    var a : FilePath = "C:";
     untyped a.separator = asys.data.Separator.WinSeparator;
    
    isTrue(a.isAbsolute());
   
    untyped a.path = ".\\something";
    
    isFalse(a.isAbsolute());
    
    untyped a.path = "\\something";
    
    isFalse(a.isAbsolute());
    
    untyped a.path = "other\\something";
    
    isFalse(a.isAbsolute());
    
    
    untyped a.separator = asys.data.Separator.PosixSeparator;
    
    untyped a.path = '/rootish';
    
    isTrue(a.isAbsolute());
  }
  public function testIsDirectory(){
    var a : FilePath = "C:\\win\\hope";
    setwin(a);
    isFalse(a.isDirectory());
    
    untyped a.path = "C:\\win\\hope\\";
    
    isTrue(a.isDirectory());
    
    setpos(a);
    
    setpath(a,'posix/thing.ogg');
    
    isFalse(a.isDirectory());
    
    setpath(a,'posix/thing/');
    isTrue(a.isDirectory());
  }
  public function testFilename(){
    var a : FilePath = '/path/to/file.wav';
    equals('file.wav',a.getFileName());
    equals('file',a.getFileBase());
    setpath(a,'path/');
    equals(null,a.getFileBase()); 
  }
  function setwin(v:FilePath){
    untyped v.separator = asys.data.Separator.WinSeparator;
  }
  function setpos(v:FilePath){
    untyped v.separator = asys.data.Separator.PosixSeparator;
  }
  function setpath(v:FilePath,path:String){
    untyped v.path = path;
  }
}