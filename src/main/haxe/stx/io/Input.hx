package stx.io;

typedef InputDef  = ProxyCat<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IoFailure>;

@:callable @:forward abstract Input(InputDef) from InputDef{
  public function new(ipt:StdIn){
    var rec : ProxyCat<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IoFailure> = null;
        rec = new ProxyCat(
          function rec(req):Proxy<Closed,Noise,InputRequest,InputResponse,Noise,IoFailure>{
            var effect = 
              ipt.apply(req)
               .convert((res) -> switch(res){
                 case IResSpent : __.ended(Tap);
                 default        : __.yield(res,rec);
               }
              ).control(
                (e:Err<IoFailure>) -> Ended(End(e))
              );
            return __.belay(effect);
          }
        );
    this = (Unary.lift(rec):InputDef);
  }
}