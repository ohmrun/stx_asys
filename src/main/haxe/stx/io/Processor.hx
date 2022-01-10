package stx.io;

import stx.coroutine.Core;


// Process = <Closed,Noise,ProcessRequest,ProcessResponse,Noise,IoFailure>

typedef ProcessorConfigDef = {
  final default_input_request : InputRequest; 
}
class Processor{
  static public function apply<R>(self:ProcessDef,ok_parser:InputParser<R>,no_parser:InputParser<ProcessFailure>,hung : (num_calls:Int, ?last_timestamp:Float) -> Option<Rejection<ProcessFailure>>,config:ProcessorConfigDef) : Outlet<R,ProcessFailure> {
    var errored   = false;
    var ok_parser = ok_parser;
    var no_parser = no_parser;
    function f(self:ProcessDef):OutletDef<R,ProcessFailure>{
       return switch(self){
        case Await(_,arw) : f(arw(Noise));
        case Yield(y,arw) : switch(y){
          case PResState(state) : 
            switch(state.status){
              case Io_Process_Init                            :
                switch(state.exit_code){
                  case Some(0) | None      : switch(ok_parser){
                    case Wait(fn)             : 
                      //If Wait then request input from Process
                      final next_proxy                = arw(PReqInput(config.default_input_request,false));
                      f(next_proxy);
                    case Emit(e,rest)         : 
                      //Pass input request from Output to Process
                      final next_proxy                = arw(PReqInput(e,false));
                      ok_parser                       = rest;
                      f(next_proxy);
                    case Hold(ft)             :
                      //final next_proxy                = __.yield(,arw);
                      //f(next_proxy,__.hold(ft),no_parser);
                      final status = Io_Process_Hung(1,haxe.Timer.stamp());
                      // f(
                      //   __.yield(state.with_status(status),arw),
                      //   __.hold(ft),
                      //   no_parser
                      // );
                      __.belay(
                        ft.convert(
                          ok_parserI -> {
                            ok_parser = ok_parserI;
                            return f(arw(PReqInput(config.default_input_request,false)));
                          }
                        )
                      );
                    case Halt(Production(r))  :
                      __.ended(Val(r));
                      //TODO close process
                    case Halt(Terminated(Stop))  :
                      __.ended(Tap);
                    case Halt(Terminated(Exit(rejection)))  :
                       __.ended(End(rejection));
                  }
                  case Some(x)  : 
                    errored = true;
                    return switch(no_parser){
                      case Emit(o,next) : 
                        final next_process_step = arw(PReqInput(o,true));
                        no_parser  = next;
                        f(next_process_step);
                        null;
                      case Wait(tran)   :
                        final next_proxy                = arw(PReqInput(config.default_input_request,true));
                        f(next_proxy);
                      case Hold(held)   :
                        __.belay(held.convert(
                          (next_no_parser) -> {
                            no_parser = next_no_parser;
                            return f(arw(PReqInput(config.default_input_request,true)));
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
              case Io_Process_Open                            :
                switch(errored){
                  case true   : f(arw(PReqInput(config.default_input_request,true)));
                  case false  : f(arw(PReqInput(config.default_input_request,false)));
                }
              case Io_Process_Hung(num_calls,last_timestamp) :
                switch(hung(num_calls,last_timestamp)){
                  case None             : f(arw(PReqTouch));
                  case Some(rejection)  : __.ended(End(rejection));
                } 
            }
            //:ProcessState
            null;
          case PResValue(res)   :
            //Outcome<InputResponse,InputResponse>
            var is_error = null;
            $type(res);
            switch(res){
              case Success(ok) : 
                is_error  = false;
                ok_parser = ok_parser.provide(ok);
              case Failure(no) :
                is_error  = true;
                no_parser = no_parser.provide(no);
            }
            f(arw(PReqInput(config.default_input_request,is_error)));
          case PResError(raw)   :
            $type(raw);
            //__.end
            //Rejection<ProcessFailure>
            null;
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
    return null;
  }
  // static public function init(next){

  // }
}