package stx.io.process.client.term;

/**
  Makes a request and emits __ended(r) with whatever the process says
**/
abstract Request(ProcessClientDef<ProcessResponse>) from ProcessClientDef<ProcessResponse> to ProcessClientDef<ProcessResponse>{
  public function new(request){
    this = __.await(
      request,
      cat
    );
  }
  static public function cat(res:ProcessResponse):ProcessClientDef<ProcessResponse>{
    __.log().debug('$res');
    return __.ended(Val(res));   
  }
}