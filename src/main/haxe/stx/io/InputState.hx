package stx.io;

enum InputStateSum{
  Io_Input_Unknown;
  Io_Input_Eager;
  Io_Input_Blocked;
  Io_Input_Closed(?external:Bool);
  Io_Input_Error(error:Error<String>);
}
@:forward abstract InputState(InputStateSum) from InputStateSum to InputStateSum{
  public function new(self) this = self;
  static public function lift(self:InputStateSum):InputState return new InputState(self);

  public function prj():InputStateSum return this;
  private var self(get,never):InputState;
  private function get_self():InputState return lift(this);
}