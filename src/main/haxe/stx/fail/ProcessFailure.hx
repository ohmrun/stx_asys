package stx.fail;

enum ProcessFailure{
  E_Process_Coroutine(e:CoroutineFailure<Noise>);
  E_Process(code:Int,?explanation:String);
}