package stx.io;
 
using stx.Coroutine;

typedef OutputDef = Coroutine<OutputRequest,Report<IoFailure>,Noise,IoFailure>;

@:using(stx.io.Output.OutputLift)
@:callable @:forward abstract Output(OutputDef) from OutputDef to OutputDef{
  static public function pure(self:StdOut):Output{
    return new Output(self);
  }
  public function new(opt:StdOut){
    this = __.wait(
      Transmission.fromFun1R(function rec(req:OutputRequest) {
        return __.hold(opt.apply(req).toProvide().convert(
          (report:Report<IoFailure>) -> report.fold(
            (e:Err<IoFailure>) -> __.exit(e.map(E_Coroutine_Subsystem)),
            () -> __.wait(Transmission.fromFun1R(rec))
          )
        ));
      })
    );
  }
}
class OutputLift{

}