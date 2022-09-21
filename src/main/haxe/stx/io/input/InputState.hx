package stx.io.input;

enum InputStateSum{
  Io_Input_Unknown;
  Io_Input_Eager;
  Io_Input_Blocked;
  Io_Input_Closed(error:Option<Error<String>>,external:Bool);
  Io_Input_Error(f:IoFailure);
}
@:forward abstract InputState(InputStateSum) from InputStateSum to InputStateSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:InputStateSum):InputState return new InputState(self);

  public function prj():InputStateSum return this;
  private var self(get,never):InputState;
  private function get_self():InputState return lift(this);

  public function is_open(){
    return switch(this){
      case Io_Input_Closed(_,_) : false;
      default : true;
    }
  }
}