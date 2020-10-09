package stx.io;

using stx.Coroutine;

typedef InputDef  = Coroutine<InputRequest,InputResponse,Noise,IoFailure>;

@:callable @:forward abstract Input(InputDef) from InputDef{
  public function new(ipt:StdIn){
    this = __.wait(
      Transmission.fromFun1R(
        function rec(req:InputRequest){
          var result = ipt.apply(req).convert(
            (res:InputResponse) -> {
              var result = __.emit(res,__.wait(Transmission.fromFun1R(rec)));
              return result;
            }
          );
          return __.hold(result);
        }
      )
    );
  }
}