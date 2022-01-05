package stx.io.process;

typedef ProcessStateDef = {
  final status          : ProcessStatus;
  final exit_code       : Option<Int>;
  final stdout          : Option<InputState>;
  final stderr          : Option<InputState>;
}
@:forward abstract ProcessState(ProcessStateDef) from ProcessStateDef to ProcessStateDef{
  public function new(self) this = self;
  static public function lift(self:ProcessStateDef):ProcessState return new ProcessState(self);

  static public inline function make(status, exit_code=None, stderr = None, stdout = None){
    return lift({
      status          : status,
      exit_code       : exit_code,
      stderr          : stderr,
      stdout          : stdout 
    });
  }
  public function prj():ProcessStateDef return this;
  private var self(get,never):ProcessState;
  private function get_self():ProcessState return lift(this);
}