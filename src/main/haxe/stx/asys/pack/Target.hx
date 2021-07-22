package stx.asys.pack;

enum TargetSum{
  Js;
  Lua;
  Swf;
  Neko;
  Php;

  Cpp;
  Cppia;

  Cs;
  Java;

  Python;

  Hl;
  
  Interp;
}

@:using(stx.asys.pack.Target.TargetLift)
abstract Target(TargetSum) from TargetSum to TargetSum{
  static public var _(default,never) = TargetLift;

  public function new(self) this = self;
  @:noUsing static public function lift(self:TargetSum):Target return new Target(self);
  

  public function prj():TargetSum return this;
  private var self(get,never):Target;
  private function get_self():Target return lift(this);

  @:noUsing static public function fromString(str:String):Target{
    return switch(str){
      case "swf"    : Swf;
      case "js"     : Js;
      case "php"    : Php;
      case "neko"   : Neko;
      case "cpp"    : Cpp;
      case "cs"     : Cs;
      case "java"   : Java;
      case "python" : Python;
      case "lua"    : Lua;
      case "hl"     : Hl;
      case "interp" : Interp;
      default       : 
        trace(str);
        throw __.fault().err(E_Undefined);
    }
  }
}
class TargetLift{
  static public function list(){
    return new Enum(TargetSum).constructs();
  }
  static public function toBuildDirective(target:Target):Option<String>{
    return switch (target) {
      case Swf            : Some("swf");
      case Js             : Some("js");
      case Php            : Some("php");
      case Neko           : Some("neko");
      case Cpp            : Some("cpp");
      case Cs             : Some("cs");
      case Java           : Some("java");
      case Python         : Some("python");
      case Lua            : Some("lua");
      case Hl             : Some("hl");
      case Interp         : Some("interp");
      default             : None;
    }
  }
  
  static public function canonical(target:Target):String{
    return new EnumValue(target.prj()).ctr();
  }
}