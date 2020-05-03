package stx.io.pack;

typedef OutputDef = Arrowlet<Packet,ClientT<Noise,Packet,Noise,IOFailure>>;

import stx.proxy.core.head.data.Client  in ClientT;
import stx.proxy.core.head.data.Server  in ServerT;
import stx.io.pack.StdOut          in AsysStdOut;

@:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  public function new(opt:AsysStdOut){
    var rec = null;
        rec = 
          function rec(pkt:Packet):ClientT<Noise,Packet,Noise,IOFailure>{ 
            return Later(
              Receiver.lift(opt.apply(pkt).fold(
                (err:TypedError<IOFailure>) -> Ended(End(err)),
                ()                          -> Await(Noise,rec)
              )(Automation.unit()))
            );
          }
    return __.arw().fn()(rec);
  }
}