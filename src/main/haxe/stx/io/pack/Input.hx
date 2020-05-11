package stx.io.pack;


typedef InputDef  = ProxyCat<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IOFailure>;

@:forward abstract Input(InputDef) from InputDef{
  public function new(ipt:StdIn){
    var rec : ProxyCat<InputRequest,Closed,Noise,InputRequest,InputResponse,Noise,IOFailure> = null;
        rec = new ProxyCat(
          function rec(req):Proxy<Closed,Noise,InputRequest,InputResponse,Noise,IOFailure>{
            var effect = 
              ipt.apply(req)
               .process((res) -> switch(res){
                 case IResSpent : __.ended(Tap);
                 default        : __.yield(res,rec);
               }
              ).control(
                (e:Err<IOFailure>) -> Ended(End(e))
              );
            return __.belay(effect);
          }
        );
    this = (rec:InputDef);
  }
}