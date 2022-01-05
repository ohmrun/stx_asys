package stx.io;

using stx.Coroutine;

typedef InputDef  = Coroutine<InputRequest,InputResponse,Noise,IoFailure>;

@:using(stx.io.Input.InputLift)
@:callable @:forward abstract Input(InputDef) from InputDef{
  static public var _(default,never) = InputLift;
  public function new(ipt:StdIn){
    this = ipt.reply();
  }
  //@:noUsing static public 
}
class InputLift{
  
}