package stx.fail;

enum ProcessFailure{
  E_ProcessState(state:ProcessStateDef);
  E_Process(code:Int,?explanation:String);
  E_Process_Io(err:IoFailure);
  E_Process_Parse(fail:stx.parse.core.ParseError);
  E_Process_Raw(bytes:haxe.io.Bytes);
}