package stx.fail;

enum ProcessFailureSum{
  E_ProcessState(state:stx.io.process.ProcessState.ProcessStateDef);
  E_Process(code:Int,?explanation:String);
  E_Process_Io(err:IoFailure);
  E_Process_Parse(fail:ParseFailure);
  E_Process_Raw(bytes:haxe.io.Bytes);
  E_Process_Unsupported(explanation:String);
}
abstract ProcessFailure(ProcessFailureSum) from ProcessFailureSum to ProcessFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ProcessFailureSum):ProcessFailure return new ProcessFailure(self);

  public function prj():ProcessFailureSum return this;
  private var self(get,never):ProcessFailure;
  private function get_self():ProcessFailure return lift(this);
}