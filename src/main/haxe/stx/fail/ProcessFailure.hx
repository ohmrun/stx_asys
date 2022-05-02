package stx.fail;

enum ProcessFailure{
  E_ProcessState(state:stx.io.process.ProcessState.ProcessStateDef);
  E_Process(code:Int,?explanation:String);
  E_Process_Io(err:IoFailure);
  E_Process_Parse(fail:stx.parse.core.ParseRefuse);
  E_Process_Raw(bytes:haxe.io.Bytes);
}