package stx.io.pack;

typedef OutputDef = ProxyCat<OutputRequest,Noise,OutputRequest,Noise,Closed,Noise,IOFailure>;

@:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  public function new(opt:StdOut){
    var rec = null;
        rec = 
          function(pkt:OutputRequest):Proxy<Noise,OutputRequest,Noise,Closed,Noise,IOFailure>{ 
            return __.belay(
              opt.apply(pkt)
                .then(
                  (report:Report<IOFailure>) -> report.fold(
                    (err:Err<IOFailure>) -> Ended(End(err)),
                    ()                          -> switch(pkt){
                      case OReqValue(_) : Await(Noise,rec);
                      case OReqClose    : __.ended(Tap);
                    }
                  )
                )
            );
          }
    this = (rec:OutputDef);
  }
}