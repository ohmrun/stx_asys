package sys.stx.io.process.client.term;

#if (sys || nodejs)
/**
  Demands IReqTotal from the stdout/stderr of a process.
**/
abstract Reply(ProcessClientDef<Bytes>) from ProcessClientDef<Bytes> to ProcessClientDef<Bytes>{
  public function new(?error=false){
    this = __.await(
      PReqInput(IReqTotal(),error),
      cat
    );
  }
  static public function cat(res:ProcessResponse):Proxy<ProcessRequest,ProcessResponse,Noise,Closed,Bytes,ProcessFailure>{
    __.log().trace('$res');
    return switch(res){
      case PResValue(Failure(IResBytes(bytes))) : __.ended(End(__.fault().of(E_Process_Raw(bytes))));
      case PResValue(Success(IResBytes(bytes))) : __.ended(Val(bytes));
      case PResError(raw)                       : __.ended(End(raw));
      case PResOffer(req)                       : __.await(req,cat);
      case PResState(state)                     : __.ended(End(__.fault().of(E_ProcessState(state))));
      case PResBlank                            : __.await(PReqTouch,cat);
      default                                   : __.ended(End(__.fault().of(E_Process_Unsupported('$res'))));
    }
  }
}
#end