package stx.io;

using stx.Coroutine;

typedef InputDef  = Coroutine<InputRequest,InputResponse,Noise,IoFailure>;

@:callable @:forward abstract Input(InputDef) from InputDef{
  public function new(ipt:StdIn){
    this = ipt.reply();
  }
  //@:noUsing static public 
}