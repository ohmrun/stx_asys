package stx.io.pack;

typedef OutputDef = Unary<Packet,ClientDef<Noise,Packet,Noise,IOFailure>>;

@:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  public function new(opt:StdOut){
    var rec = null;
        rec = 
          function(pkt:OutputRequet):ClientDef<Noise,Packet,Noise,IOFailure>{ 
            return __.belay(opt.apply(pkt).
              then(
                (report) -> report.fold(
                  (err:TypedError<IOFailure>) -> Ended(End(err)),
                  ()                          -> switch(pkt){
                    case OReqValue(_) : Await(Noise,rec);
                    case OReqClose:   : __.ended(Tap);
                  }
                )
              ));
          }
    return rec;
  }
}