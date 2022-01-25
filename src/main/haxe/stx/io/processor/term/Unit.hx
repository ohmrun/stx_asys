package stx.io.processor.term;

using stx.Parse;
using stx.parse.Core;

using stx.coroutine.Core;

class Unit extends ProcessorCls<Bytes>{
  public function new(process){
    super(process,new Interpreter().reply());
  }
}
/**
  Asks for all the input from stdin. Borks otherwise. Quite lossy.
**/
private class Interpreter{
  public function new(){}
  public function reply():Coroutine<Outcome<InputResponse,InputResponse>,ProcessRequest,Bytes,ProcessFailure>{
    return __.emit(
      PReqInput(IReqTotal(),false),
      __.tran(
        function f(outcome:Outcome<InputResponse,InputResponse>){
          return outcome.fold(
            ok -> switch(ok){
              case IResValue(packet) : __.prod(packet.toBytes());
              case IResBytes(b,_)    : __.prod(b);
              case IResSpent         : __.term(__.fault().explain(_ -> _.e_input_unexpected_end()));
              case IResState(state)  : switch(state){
                case Io_Input_Closed(error,_) :
                  switch(error){
                    case Some(err) : __.term(err.toRejection());
                    case None      : __.term(__.fault().explain(_ -> _.e_input_unexpected_end()));
                  }
                case Io_Input_Error(f)        : 
                  __.term(__.fault().of(E_Process_Io(f)));
                default : 
                  __.tran(f);
              }
            },
            (no) -> {
              return __.term(__.fault().of(E_Process_Io(E_Io_UnsupportedValue)));
            }
          );
        }
      )
    );
  }
}