package stx.io;

using stx.coroutine.Core;

import stx.io.StdIn  in AsysStdIn;
import stx.io.StdOut in AsysStdOut;

typedef ProcessDef = ServerDef<ProcessRequest,ProcessResponse,Noise,ProcessFailure>;

@:using(stx.Proxy.ProxyLift)
@:using(stx.io.Process.ProcessLift)
abstract Process(ProcessDef) from ProcessDef to ProcessDef{
  static public var _(default,never) = ProcessLift;
  @:noUsing static public function lift(self:ProcessDef):Process{
    return new Process(self);
  }
  public function new(self){this = self;}
  //TODO fetch state from io
  @:noUsing static public function make0(self:sys.io.Process,ins:OutputDef,outs:InputDef,errs:InputDef):Process{
    __.log().debug('Process.make0');
    var exit_code                               = None;
    var found_errors                            = false;
    var errors_state                            = None;
    var output_state                            = None; 
    var process_status :  ProcessStatus         = Io_Process_Open;

    function get_process_state(){
      return ProcessState.make(process_status,exit_code,errors_state,output_state);
    }
    function step(self:sys.io.Process,ins:OutputDef,outs:InputDef,errs:InputDef,req:ProcessRequest):ProcessDef{
      return __.yield(
        PResState(ProcessState.make(process_status)),
        function rec(req:ProcessRequest):ProcessDef{
          __.log().debug(_ -> _.pure(req));
          return switch (req){
            case PReqTouch                   : __.yield(PResState(get_process_state()),rec);
            case PReqState(block)            :
              exit_code       = __.option(self.exitCode(__.option(block).defv(true))); 
              function get_state(x) return switch(x){
                case IResState(state)     : __.option(x);
                default                   : None;
              }
              function choose_first_state_response(x,y){
                return switch(y){
                  case Some(IResState(x)) : y;
                  default                 : x;
                };
              }
              final out_state = Emiter._.derive(
                Tunnel._.emiter(outs,Emiter.pure(IReqState)),
                get_state,
                choose_first_state_response,
                None
              ).map(
                res -> switch(res){
                  case Some(IResState(state)) : __.option(state);
                  default                     : __.option(null);
                }
              );
              final err_state = Emiter._.derive(
                Tunnel._.emiter(errs,Emiter.pure(IReqState)),
                get_state,
                choose_first_state_response,
                None
              ).map(
                res -> switch(res){
                  case Some(IResState(state)) : __.option(state);
                  default                     : __.option(null);
                }
              );
              final either = err_state.zip(out_state);
              final apply  = Action.fromEffect(
                either.secure(
                  Secure.handler(
                  (x:Couple<Option<InputState>,Option<InputState>>) -> {
                    x.decouple(
                      (out,err) -> {
                          output_state  = out;
                          errors_state  = err;
                      }
                    );
                  }
                  )
                )
              );
              //$type(apply);
              // RespondCat._.next(
              //   apply,
              //   (_)  ->  __.yield(PResState(get_process_state()),rec)
              // );
              //TODO call this;
              __.yield(PResState(get_process_state()),rec);
            case PReqInput(req,false)      : 
              switch(outs.provide(req)){
                case Emit(x,next)       : __.yield(PResValue(Success(x)),step.bind(self,ins,next,errs));
                case Wait(arw)          : 
                    process_status = Io_Process_Open;
                  __.yield(PResState(get_process_state()),step.bind(self,ins,__.wait(arw),errs));
                case Hold(held)         : 
                  process_status = process_status.hang();
                  //TODO The state report is *behind the asynchronous gap
                  __.belay(
                    stx.proxy.core.Belay.lift(
                      held.map(
                        next -> __.yield(PResState(get_process_state()),step.bind(self,ins,next,errs)) 
                      )
                    )
                  );
                case Halt(ret)          : __.yield(PResValue(Success(IResSpent)),step.bind(self,ins,Halt(ret),errs));
              }
              case PReqInput(req,true)      : 
                switch(errs.provide(req)){
                  case Emit(x,next)       : __.yield(PResValue(Success(x)),step.bind(self,ins,outs,next));
                  case Wait(arw)          : 
                    process_status = Io_Process_Open;
                    __.yield(PResState(get_process_state()),step.bind(self,ins,outs,__.wait(arw)));
                  case Hold(held)         : 
                    process_status = process_status.hang();
                    __.belay(
                      stx.proxy.core.Belay.lift(held.map(
                        next -> __.yield(PResState(get_process_state()),step.bind(self,ins,outs,next))
                      ))
                    );
                  case Halt(ret)          : __.yield(PResValue(Success(IResSpent)),step.bind(self,ins,outs,Halt(ret)));
                }
              case PReqOutput(req)  :   
                __.yield(PResState(get_process_state()),step.bind(self,ins.provide(req),outs,errs));
          }
        }
      );
    }
    return step(self,ins,outs,errs,PReqState(false));
  }
  static public function make(command:Cluster<String>,?detached:Bool):Process{
    var exit_code                   = None;
    
    function init():ProcessDef{
      final self                      = new sys.io.Process(command.head().fudge(), Std.downcast(command.tail(),Array),detached);
      final ins                       = AsysStdOut.lift(self.stdin).reply();
      final outs                      = AsysStdIn.lift(self.stdout).reply();
      final errs                      = AsysStdIn.lift(self.stderr).reply();    
      return make0(self,ins,outs,errs);
    }; 
  
    return lift(__.belay(Belay.fromThunk(init)));
  }
  public function prj():ProcessDef{
    return this;
  }
}
class ProcessLift{
  static inline public function lift(self:ProcessDef):Process{
    return Process.lift(self);
  }
  static public function provide(self:Process,req:ProcessRequest):Process{
    return lift(Server._.provide(self.prj(),req));
  }
  static public function drain(self:ProcessDef,?buffer):Process{
    var that  = provide(self,PReqInput(IReqTotal(buffer),false));
    return that;
  }
}