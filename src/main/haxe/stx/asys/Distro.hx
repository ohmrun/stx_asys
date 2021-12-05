package stx.asys;

enum abstract Distro(String){
  static public function unit():Distro{
    return new Distro();
  }
  var Windows;
  var Linux;
  var BSD;
  var Mac;

  public function new(){
    this = switch(std.Sys.systemName()){
      case "Windows"  : "Windows"; 
      case "Linux"    : "Linux";
      case "BSD"      : "BSD";
      case "Mac"      : "Mac";
      case x          :  throw __.fault().external('E_UnknownDistroName($x)');
    }
  }
  public function is_windows(){
    return this == "Windows";
  }
}