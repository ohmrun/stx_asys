package stx.io.process.client.term;

class NotErrored{
  static public function make<R>(next:ProcessClientDef<R>){
    return __.await(
      PReqState(false),
      (y) -> {
        switch(y){
          case PResState(p) : switch(p.exit_code.prj()){
            case None     : next;
            case Some(0)  : next;
            case Some(x)  : __.ended(End(__.fault().of(E_Process(x))));
          }
          default : __.ended(End(__.fault().of(E_Process_Unsupported('Server did not respond to status request'))));
        }
      }
    );
  }
}