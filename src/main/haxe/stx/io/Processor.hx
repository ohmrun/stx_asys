package stx.io;

import stx.coroutine.Core;


// Process = <Closed,Noise,ProcessRequest,ProcessResponse,Noise,IoFailure>
class Processor{
  static public function apply<R>(self:ProcessDef,ok_parser:InputParser<R>,no_parser:InputParser<ProcessFailure>,hung : (num_calls:Int, ?last_timestamp:Float) -> Option<Rejection<ProcessFailure>>) : Outlet<R,ProcessFailure> {
    var errored   = false;
    var ok_parser = ok_parser;
    var no_parser = no_parser;
    function f(self:ProcessDef):OutletDef<R,ProcessFailure>{
      function no_step(arw){
        return switch(no_parser){
          case Emit(o,next) : 
            final next_process_step = arw(PReqInput(o,true));
            no_parser  = next;
            f(next_process_step);
          case Wait(tran)   :
            __.ended(End(__.fault().explain(_ -> _.e_input_parser_waiting_on_an_unitialized_process())));
          case Hold(held)   :
            __.belay(held.convert(
              (next_no_parser) -> {
                no_parser = next_no_parser;
                return f(self);
              }
            ));
          case Halt(Production(r))  :
            __.ended(End(Rejection.fromError(r.error.toError()).errate(E_Process_Parse)));
          case Halt(Terminated(Stop))  :
            __.ended(Tap);
          case Halt(Terminated(Exit(rejection))) :
            __.ended(End(rejection.errate(E_Process_Parse)));  
        }
      }
      function ok_step(arw){
        __.log().debug(_ -> _.pure(ok_parser));
        return switch(ok_parser){
          case Wait(fn)             : 
            __.ended(End(__.fault().explain(_ -> _.e_input_parser_waiting_on_an_unitialized_process())));
          case Emit(e,rest)         : 
            //Pass input request from Output to Process
            final next_proxy                = arw(PReqInput(e,false));
            __.log().debug(_ -> _.pure(next_proxy));
            ok_parser                       = rest;
            f(next_proxy);
          case Hold(ft)             :
            final status = Io_Process_Hung(1,haxe.Timer.stamp());
            __.belay(
              ft.convert(
                ok_parserI -> {
                  ok_parser = ok_parserI;
                  //try again with the new parser state.
                  return f(self);
                }
              )
            );
          case Halt(Production(r))  : 
            r.toRes().fold(
              opt -> opt.fold(
                ok -> __.ended(Val(ok)),
                () -> __.ended(Tap)
              ),
              e -> __.ended(e.errate(E_Process_Parse))
            );
            //TODO close process
          case Halt(Terminated(Stop))  :
            __.ended(Tap);
          case Halt(Terminated(Exit(rejection)))  :
             __.ended(End(rejection.errate(E_Process_Parse)));
        }
      }
      __.log().debug(_ -> _.pure(self));
      return switch(self){
        case Await(_,arw) : f(arw(Noise));
        case Yield(y,arw) : switch(y){
          case PResState(state) : 
            switch(state.status){
              case Io_Process_Init                            :
                switch(state.exit_code){
                  case Some(0) | None      : 
                    ok_step(arw);
                  case Some(x)  : 
                    errored = true;
                    no_step(arw);
                }
              case Io_Process_Open                            :
                switch(errored){
                  case true   : return no_step(arw);
                  case false  : 
                    switch(state.exit_code){
                      case Some(0) | None      : 
                        ok_step(arw);
                      case Some(x)  : 
                        errored = true;
                        no_step(arw);
                    }
                }
              case Io_Process_Hung(num_calls,last_timestamp) :
                switch(hung(num_calls,last_timestamp)){
                  case None             : __.belay(Belay.fromThunk(f.bind(arw(PReqTouch))));
                  case Some(rejection)  : __.ended(End(rejection));
                } 
            }
          case PResValue(res)   :
            //Outcome<InputResponse,InputResponse>
            var is_error = null;
            switch(res){
              case Success(ok) : 
                is_error  = false;
                ok_parser = ok_parser.provide(ok);
                switch(ok_parser){
                  case Emit(emit,next) : 
                    ok_parser = next;
                    f(arw(PReqInput(emit,false)));
                  case Wait(wait) :
                    f(arw(PReqTouch));
                  case Hold(held) : 
                    __.belay(held.convert(x -> {
                        ok_parser = x;
                        return f(self);
                      })
                    );
                  case Halt(Production(r)) :
                    r.toRes().fold(
                      opt -> opt.fold(
                        ok -> __.ended(Val(ok)),
                        () -> __.ended(Tap)
                      ),
                      e -> __.ended(e.errate(E_Process_Parse))
                    );
                  case Halt(Terminated(Stop))  :
                    __.ended(Tap);
                  case Halt(Terminated(Exit(rejection)))  :
                      __.ended(End(rejection.errate(E_Process_Parse)));
                }
              case Failure(no) :
                is_error  = true;
                no_parser = no_parser.provide(no);
                return switch(no_parser){
                  case Emit(o,next) : 
                    final next_process_step = arw(PReqInput(o,true));
                    no_parser  = next;
                    f(next_process_step);
                  case Wait(tran)   :
                    f(arw(PReqTouch));
                  case Hold(held)   :
                    __.belay(held.convert(
                      (next_no_parser) -> {
                        no_parser = next_no_parser;
                        return f(self);
                      }
                    ));
                  case Halt(Production(r))  :
                    __.ended(End(Rejection.fromError(r.error.toError()).errate(E_Process_Parse)));
                  case Halt(Terminated(Stop))  :
                    __.ended(Tap);
                  case Halt(Terminated(Exit(rejection))) :
                    __.ended(End(rejection.errate(E_Process_Parse)));  
                }
            }
          case PResError(raw)   :
            __.ended(End(raw));
        } 
        case Defer(ft)    : __.belay(ft.mod(f));
        case Ended(res)   : __.ended(
          res.fold(
            _ -> Tap,//TODO check this
            End,
            () -> Tap
          )
        );
       }
    }
    return f(self);
  }
  // static public function init(next){

  // }
}