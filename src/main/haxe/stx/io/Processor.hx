package stx.io;

import stx.coroutine.Core;

typedef ProcessorDef<R> = ProxySum<Closed,Noise,ProcessorRequest,ProcessorResponse,Option<R>,ProcessFailure>;

enum ProcessorResponse{
  PRes_InterpreterNeedsInput;
  PRes_ProcessNeedsInput;
}
enum ProcessorRequest{
  PrReqInput(ipt:InputRequest,err:Bool);
  //TODO how to integrate feeding into the process?
  //PrReqOutput 
}
class ProcessorCls<R>{
  private var process       : Process;
  /**
    The coroutine produces requests for the processor to interpret and folds over the responses
  **/
  private var interpreter   : Coroutine<Outcome<InputResponse,InputResponse>,ProcessRequest,R,ProcessFailure>;

  public function new(process,interpreter){
    this.process      = process;
    this.interpreter  = interpreter;
  }
  public function reply():Processor<R>{
    return Processor.lift(PushCat._.next(
      Proxy._.map(process.prj(),_ -> None),
      function f(y:ProcessResponse):Proxy<ProcessRequest,ProcessResponse,ProcessorRequest,ProcessorResponse,Option<R>,ProcessFailure>{
        __.log().debug(_ -> _.pure(y));
        return switch(y){
          case PResState(state) : 
            switch(state.status){
              case Io_Process_Init | Io_Process_Open: 
                switch(interpreter){
                  case Emit(req,emit) : 
                    this.interpreter  = emit;
                    __.await(req,f);
                  case Wait(wait)     : 
                    __.yield(PRes_InterpreterNeedsInput,
                      (req:ProcessorRequest) -> {
                        //$type(req);
                        return switch(req){
                          case PrReqInput(ipt,err) : 
                            __.await(PReqInput(ipt,err),f);
                        }
                      }
                    );
                  case Hold(held)     : 
                    __.belay(
                      held.convert(
                        (next) -> {
                          this.interpreter = next;
                          return __.await(PReqTouch,f);
                        }
                      )
                    );
                  case Halt(Production(r))              : __.ended(Val(Some(r)));
                  case Halt(Terminated(Stop))           : __.ended(Tap);
                  case Halt(Terminated(Exit(e)))        : __.ended(End(e));
                }
              case Io_Process_Hung(_,_) : 
                __.await(PReqTouch,f);
            }
          case PResValue(res)   :
            this.interpreter = this.interpreter.provide(res);
            switch(interpreter){
              case Halt(Production(r))              : __.ended(Val(Some(r)));
              case Halt(Terminated(Stop))           : __.ended(Tap);
              case Halt(Terminated(Exit(e)))        : __.ended(End(e));
              case Hold(held)                       :
                __.belay(
                  held.convert(
                    (next) -> {
                      this.interpreter = next;
                      return __.await(PReqTouch,f);
                    }
                  )
                );
              case Emit(req,emit) : 
                //this.process      = process.provide(req);
                this.interpreter  = emit;
                __.await(req,f);
              case Wait(wait)     : 
                __.await(PReqTouch,f);
            }
          case PResError(raw)  :
            //Rejection<ProcessFailure>
            __.ended(End(raw));
          case PResOffer(req)   : 
            //ProcessRequest
            __.await(req,f);
        }
      }
    ));
  }
}
@:using(stx.io.Processor.ProcessorLift)
abstract Processor<R>(ProcessorDef<R>) from ProcessorDef<R> to ProcessorDef<R>{
  public function new(self) this = self;
  static public function lift<R>(self:ProcessorDef<R>):Processor<R> return new Processor(self);

  public function prj():ProcessorDef<R> return this;
  private var self(get,never):Processor<R>;
  private function get_self():Processor<R> return lift(this);

  @:to public function toProxy():Proxy<Closed,Noise,ProcessorRequest,ProcessorResponse,Option<R>,ProcessFailure>{
    return Proxy.lift(this);
  }
  // @:noUsing static public function pure(process:Process):Processor<haxe.io.Bytes>{
  //   return stx.io.processor.term.Unit
  // }
}
class ProcessorLift{
  static public function toOutlet<R>(self:ProcessorDef<R>):Outlet<Option<R>,ProcessFailure>{
    function f(self:ProcessorDef<R>):OutletDef<Option<R>,ProcessFailure>{
      return switch(self){
        case Yield(y,yield) : 
          f(yield(PrReqInput(IReqTotal(),false)));
        case Await(a,await)  : 
          __.await(a,await.then(f));
        case Ended(chk)   : 
          __.ended(chk);
        case Defer(belay) : 
          __.belay(belay.mod(f));
      }
    }
    return Outlet.lift(f(self));
  }
}
