package stx.asys.body;

class Targets{
  static public function list(){
    return new Enum(stx.asys.head.data.Target).constructs();
  }
  static public function toBuildDirective(target:Target):Option<String>{
    return switch (target) {
      case Swf            : Some("-swf");
      case Js             : Some("-js");
      case Php            : Some("-php");
      case Neko           : Some("-neko");
      case Cpp            : Some("-cpp");
      case Cs             : Some("-cs");
      case Java           : Some("-java");
      case Python         : Some("-python");
      case Lua            : Some("-lua");
      case Hl             : Some("-hl");
      case Interp         : Some("--interp");
      default             : None;
    }
  }
  static public function canonical(target:Target):String{
    return new EnumValue(target.prj()).constructor();
  }
}