package stx.io.process;

typedef ProcessStateDef = {
  final status          : ProcessStatus;
  final exit_code       : ExitCode;
  final stdout          : InputState;
  final stderr          : InputState;
}
@:forward abstract ProcessState(ProcessStateDef) from ProcessStateDef to ProcessStateDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ProcessStateDef):ProcessState return new ProcessState(self);

  static public inline function make(status, ?exit_code, stderr = Io_Input_Unknown, stdout = Io_Input_Unknown){
    return lift({
      status          : status,
      exit_code       : __.option(exit_code).def(ExitCode.unit),
      stderr          : stderr,
      stdout          : stdout 
    });
  }
  public function copy(?status,?exit_code,?stderr,?stdout){
    return lift({
      status    : __.option(status).defv(this.status),
      exit_code : __.option(exit_code).defv(this.exit_code),
      stderr    : __.option(stderr).defv(this.stderr),
      stdout    : __.option(stdout).defv(this.stdout)
    });
  }
  public function prj():ProcessStateDef return this;
  public var self(get,never):ProcessState;
  private function get_self():ProcessState return lift(this);

  public function with_status(status:ProcessStatus){
    return copy(status);
  }
  public function with_exit_code(code:ExitCode){
    return copy(null,code);
  }
  public function with_stdout(state:InputState){
    return copy(null,null,state);
  }
  public function with_stderr(state:InputState){
    return copy(null,null,null,state);
  }
}