package stx.asys.core.fs.pack;


class Path{
  var separator : Separator;
  var path      : String;
  
  public function new(?path,?separator){
    if(separator == null){
      this.separator = new Seperator();
    }else{
      this.separator = separator;
    }
    this.path = path == null ? "." : path;
  }
  public function getFileBase(){
  
  }
  public function getDrive():Option<String>{
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
}