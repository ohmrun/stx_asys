package stx.io.body;

import stx.proxy.core.head.data.Server  in ServerT;
import stx.io.pack.StdIn           in AsysStdIn;
import stx.io.head.data.Input      in InputT;

class Inputs{ 
  static public function request(ipt:StdIn):Consumer<InputRequest,InputResponse,IOFailure>{
    var folder = Res._.fold.bind(
      (x)         -> Ended(Right(x)),
      (e)         -> Ended(Left(e))
    );
    var arw    = Attempts.fromIOConstructor((ipt:AsysStdIn).apply);
    return Await(Noise,
      arw.prj().postfix(folder)
    );
  }
}