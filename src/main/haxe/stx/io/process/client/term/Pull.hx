package stx.io.process.client.term;

/**
  Requires a chunk from the stdout/stderr of a process.
**/
abstract Pull(ProcessClientDef<Bytes>) from ProcessClientDef<Bytes> to ProcessClientDef<Bytes>{
  public function new(size:ByteSize,?error=false){
    if(size == null) {
      size = I8;
    }
    this = __.await(
      PReqInput(size,error),
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
      case PResBlank                            : __.await(PReqTouch,cat);
      default                                   : __.ended(End(__.fault().of(E_Process_Unsupported('$res'))));
    }
  }
}