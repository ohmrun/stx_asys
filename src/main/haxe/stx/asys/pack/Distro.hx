package stx.asys.pack;

enum abstract Distro(String){
  static public function unit():Distro{
    return new Distro();
  }
  var Windows;
  var Linux;
  var BSD;
  var Mac;

  public function new(){
    this = switch(Sys.systemName()){
      case "Windows"  : "Windows"; 
      case "Linux"    : "Linux";
      case "BSD"      : "BSD";
      case "Mac"      : "Mac";
      case _          :  throw __.fault().of(UnknownDistroName);
    }
  }
  public function is_windows(){
    return this == "Windows";
  }
}