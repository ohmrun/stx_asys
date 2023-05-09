package sys.stx.io.process.client.term;

#if (sys || nodejs)
class Timer{
  static public function make<R>(ms:Int,next:ProcessClientDef<R>):ProcessClientDef<R>{
    return __.belay(
      Belay.fromFuture(
        () -> {
          //__.log().trace('belay called');
          return new Future(
            function(cb:stx.proxy.core.Client.ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>->Void) {
              //__.log().debug('Timer started $ms');
              final delay = stx.pico.Delay.comply(
                () -> {
                  //__.log().debug('Timer called');
                  cb(next);
                },
                ms
              );
              return delay.cancel;//Thanks Juraj
            }
          );
        }
      )
    );
  }
}
#end