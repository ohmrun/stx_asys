package stx.io.process.client.term;

/**
  Requires all the bytes from the stdout of a process.
**/
abstract Reply(ProcessClientDef<Bytes>) from ProcessClientDef<Bytes> to ProcessClientDef<Bytes>{
  public function new(){
    this = __.await(
      PReqInput(IReqTotal(),true),
      cat
    );
  }
  static public function cat(res:ProcessResponse):ProcessClientDef<Bytes>{
    __.log().debug('$res');
    return switch(res){
      case PResValue(Failure(IResBytes(bytes))) : __.ended(End(__.fault().of(E_Process_Raw(bytes))));
      case PResValue(Success(IResBytes(bytes))) : __.ended(Val(bytes));
      case PResError(raw)                       : __.ended(End(raw));
      case PResOffer(req)                       : __.await(req,cat);
      case PResState(state)                     : __.ended(End(__.fault().of(E_ProcessState(state))));
      default                                   : __.ended(End(__.fault().of(E_Process_Unsupported('$res'))));
    }
  }
}