package stx.io;

using stx.coroutine.Core;

import stx.io.StdIn  in AsysStdIn;
import stx.io.StdOut in AsysStdOut;

typedef ProcessDef = ServerDef<ProcessRequest,ProcessResponse,Noise,IoFailure>;

@:using(stx.io.Process.ProcessLift)
abstract Process(ProcessDef) from ProcessDef{
  static public var _(default,never) = ProcessLift;
  @:noUsing static public function lift(self:ProcessDef):Process{
    return new Process(self);
  }
  public function new(self){this = self;}
  @:noUsing static public function make0(self:sys.io.Process,ins:OutputDef,outs:InputDef,errs:InputDef,req:ProcessRequest):Process{
    var exit_code                   = None;
    function step(self:sys.io.Process,ins:OutputDef,outs:InputDef,errs:InputDef,req:ProcessRequest):ProcessDef{
      return __.yield(
        PResReady,
        function rec(req:ProcessRequest):ProcessDef{
          return switch (req){
            case PReqState(block)            :
              exit_code = __.option(self.exitCode(__.option(block).defv(true))); 
              __.yield(PResState(({ exit_code : exit_code }:ProcessState)),rec);
            case PReqInput(req,false)      : 
              switch(outs.provide(req)){
                case Emit(x,next)       : __.yield(PResValue(Success(x)),step.bind(self,ins,next,errs));
                case Wait(arw)          : __.yield(PResReady,step.bind(self,ins,__.wait(arw),errs));
                case Hold(held)         : 
                  __.belay(
                    stx.proxy.core.Belay.lift(
                      held.map(
                        next -> __.yield(PResReady,step.bind(self,ins,next,errs)) 
                      )
                    )
                  );
                case Halt(ret)          : __.yield(PResValue(Success(IResSpent)),step.bind(self,ins,Halt(ret),errs));
              }
              case PReqInput(req,true)      : 
                switch(errs.provide(req)){
                  case Emit(x,next)       : __.yield(PResValue(Success(x)),step.bind(self,ins,outs,next));
                  case Wait(arw)          : __.yield(PResReady,step.bind(self,ins,outs,__.wait(arw)));
                  case Hold(held)         : 
                    __.belay(
                      stx.proxy.core.Belay.lift(held.map(
                        next -> __.yield(PResReady,step.bind(self,ins,outs,next)) 
                      ))
                    );
                  case Halt(ret)          : __.yield(PResValue(Success(IResSpent)),step.bind(self,ins,outs,Halt(ret)));
                }
              case PReqOutput(req)  :   
                __.yield(PResReady,step.bind(self,ins.provide(req),outs,errs));
          }
        }
      );
    }
    return step(self,ins,outs,errs,req);
  }
  static public function grow(command:Cluster<String>,?detached:Bool){
    var exit_code                   = None;
    
    function init():ProcessDef{
      final self                      = new sys.io.Process(command.head().fudge(), Std.downcast(command.tail(),Array),detached);
      final ins                       = AsysStdOut.lift(self.stdin).reply();
      final outs                      = AsysStdIn.lift(self.stdout).reply();
      final errs                      = AsysStdIn.lift(self.stderr).reply();    
      return __.yield(PResReady,make0.bind(self,ins,outs,errs).fn().then(x -> x.prj()));        
    }; 
  
    return __.belay(Belay.fromThunk(init));
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
  // static public function outlet<Z>(self:ProcessDef,driver:Void->InputRequest,fn:InputResponse -> Z -> Res<Z,IoFailure>,init:Z):Outlet<Z,IoFailure>{
  //   function rec(self:ProcessDef,init:Z):OutletDef<Z,IoFailure> {
  //     return switch(self){
  //       case Await(_,next) : rec(next(Noise),init);
  //       case Yield(y,next) : 
  //         fn(y,init).fold(
  //           ok -> rec(PReqInput(next(driver())),ok),
  //           er -> Outlet.make(End(er))
  //         );
  //       case Ended(e)      : __.ended(e);
  //       case Defer(d)      : __.belay(d.map(rec.bind(_,init)));
  //     }
  //   };
  //   return lift(rec(self,init));
  // }
}