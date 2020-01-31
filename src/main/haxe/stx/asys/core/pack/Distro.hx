package stx.asys.core.pack;

enum abstract Distro(String){
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
      case _          :  __.fault().because("Unknown Distro name").throwSelf();
    }
  }
  public function is_windows(){
    return this == "Windows";
  }
}