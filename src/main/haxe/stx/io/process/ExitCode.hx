package stx.io.process;

typedef ExitCodeDef = Option<Int>;

@:forward abstract ExitCode(ExitCodeDef) from ExitCodeDef to ExitCodeDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ExitCodeDef):ExitCode return new ExitCode(self);
  static public function unit():ExitCode{
    return lift(None);
  }
  @:noUsing static public function make(self){
    return lift(Some(self));
  }
  public function prj():ExitCodeDef return this;
  private var self(get,never):ExitCode;
  private function get_self():ExitCode return lift(this);

  inline public function has_error():Bool{
    return switch(this){
      case Some(0) | None  : false;
      default              : true;
    }
  }
  inline public function is_ready():Bool{
    return this.is_defined();
  }
  
}