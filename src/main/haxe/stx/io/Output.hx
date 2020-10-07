package stx.io;


typedef OutputDef = ProxyCat<OutputRequest,Noise,OutputRequest,Noise,Closed,Noise,IoFailure>;

@:using(stx.io.Output.OutputLift)
@:callable @:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  static public function pure(self:StdOut):Output{
    return new Output(self);
  }
  public function new(opt:StdOut){
    var rec = null;
        rec = 
          function(pkt:OutputRequest):Proxy<Noise,OutputRequest,Noise,Closed,Noise,IoFailure>{ 
            return __.belay(
              opt.apply(pkt)
                .then(
                  (report:Report<IoFailure>) -> report.fold(
                    (err:Err<IoFailure>) -> Ended(End(err)),
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
  public function next<A,B,X,Y,R>(that:ProxyCat<Noise,A,B,X,Y,R,IoFailure>):ProxyCat<OutputRequest,A,B,X,Y,R,IoFailure>{
    return ProxyCat._.next(this,that);
  }
}
class OutputLift{

}