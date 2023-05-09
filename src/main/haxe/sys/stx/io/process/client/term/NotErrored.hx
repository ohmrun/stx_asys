package sys.stx.io.process.client.term;

#if (sys || nodejs)
/**
  Impatient request for state, `Ended` if `exit_code` non-zero.
**/
class NotErrored{
  static public function make<R>(next:ProcessClientDef<R>){
    return __.await(
      PReqState(false),
      (y:ProcessResponse) -> {
        __.log().trace('$next $y');
        return switch(y){
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
#end