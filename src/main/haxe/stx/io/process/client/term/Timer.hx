package stx.io.process.client.term;

class Timer{
  static public function make<R>(ms:Int,next:ProcessClientDef<R>):ProcessClientDef<R>{
    return __.belay(
      Belay.fromFuture(
        Future.irreversible.bind(
          function(cb:stx.proxy.core.Client.ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>->Void) {
            __.log().debug('Timer started $ms');
            stx.stream.Delay.comply(
              () -> {
                __.log().debug('Timer called');
                cb(next);
              },
              ms
            );
          }
        )
      )
    );
  }
}