package asys.impl;

using stx.Arrays;
using hx.Maybe;
import asys.data.Separator in TSep;
import asys.Separator;

class FilePath{
  var separator : Seperator;
  var path      : String;
  
  public function new(?path,?separator){
    if(separator == null){
      this.separator = new Seperator();
    }else{
      this.separator = separator;
    }
    this.path = path == null ? "." : path;
  }
  public function isDirectory(){
    return path.charCodeAt(path.length-1) == separator.toString().charCodeAt(0);
  }
  public function getDirectory(){
    return isDirectory() ? path :
      path.split(separator.toString()).dropRight(1).join(separator.toString());
  }
  public function getFileName():Maybe<String>{
    return isDirectory() ? null : path.split(separator.toString()).last();
  }
  public function getFileBase(){
    return getFileName().flatMap(
      function(file){
        return file.split('.').first();
      }
    );
  }
  public function getDrive():Maybe<String>{
    return switch(separator){
      case TSep.WinSeparator    : 
        if(isAbsolute()){
         path.charAt(0); 
        }else{
          null;
        }
      case _ : null;
    }   
  }
  public function isAbsolute():Bool{
    return switch(separator){
      case TSep.WinSeparator    : ~/[A-Z,a-z]:/g.match(path.substr(0,2));
      case TSep.PosixSeparator  : path.charCodeAt(0) == TSep.PosixSeparator.toString().charCodeAt(0);
      case _ : false;
    }
  }
  /*
    two by two?
  */
  public function normalize():FilePath{
   // var segs = path.split(this.separator.toString());
   // segs
  }
}