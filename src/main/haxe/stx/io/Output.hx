package stx.io;
 
using stx.Coroutine;

/**
 * Coroutine for an Output 
 */
typedef OutputDef = Coroutine<OutputRequest,Report<IoFailure>,Nada,IoFailure>;

/**
 * Coroutine for an Output 
 */
@:using(stx.coroutine.core.Coroutine.CoroutineLift)
@:using(stx.io.Output.OutputLift)
@:callable @:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  static public var _(default,never) = OutputLift;
  
  @stx.meta.pure
  @:noUsing static public function pure(self:StdOut):Output{
    return new Output(self);
  }
  public function new(self:StdOut){
    this = self.reply();
  }
}
class OutputLift{
  static public function relate(self:OutputDef):Relate<OutputRequest,Nada,IoFailure>{
    return Coroutine._.relate(self,x -> x);
  }
}