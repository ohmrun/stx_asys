package stx.fail;

enum ProcessFailure{
  E_Process(code:Int,?explanation:String);
  E_Process_Io(err:IoFailure);
  E_Process_Parse(fail:stx.parse.core.ParseError);
}