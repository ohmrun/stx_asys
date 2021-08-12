package stx.io;
 
using stx.Coroutine;

typedef OutputDef = Coroutine<OutputRequest,Report<IoFailure>,Noise,IoFailure>;

@:using(stx.io.Output.OutputLift)
@:callable @:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  static public function pure(self:StdOut):Output{
    return new Output(self);
  }
  public function new(self:StdOut){
    this = self.reply();
  }
}
class OutputLift{

}