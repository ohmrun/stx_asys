package stx.io.pack;

import stx.proxy.core.head.data.Server  in ServerT;
import stx.io.pack.StdIn           in AsysStdIn;
typedef InputDef  = Arrow<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IOFailure>

@:forward abstract Input(InputDef) from InputDef{
  public function new(ipt:AsysStdIn){
    var rec : Arrow<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IOFailure> = null;
        rec = new Arrow(
          Attempts.fromIOConstructor(ipt.apply).prj().postfix(
            Res._.fold.bind(
              (x)         -> Yield(x,rec),
              (e)         -> Ended(__.failure(e))
            )
          )
        );
    this = (rec:InputT);
  }
}