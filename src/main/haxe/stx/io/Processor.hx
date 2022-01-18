package stx.io;

import stx.coroutine.Core;

// Process = <Closed,Noise,ProcessRequest,ProcessResponse,Noise,IoFailure>
class ProcessorCls<R>{
  public final process                        : Process;
  public var stdin(default,null)              : InputParser<R>;
  public var stderr(default,null)             : InputParser<ProcessFailure>;
  public final hung                           : (num_calls:Int, ?last_timestamp:Float) -> Option<Rejection<ProcessFailure>>;

  public function new(process,stdin,stderr,hung){
    this.process  = process;
    this.stdin    = stdin;
    this.stderr   = stderr;
    this.hung     = hung;
  }
  public function reply() : Outlet<R,ProcessFailure> {
    var errored   = false;
    function f(self:ProcessDef):OutletDef<R,ProcessFailure>{
      function no_step(arw){
        return switch(stderr){
          case Emit(o,next) : 
            final next_process_step = arw(PReqInput(o,true));
            stderr  = next;
            f(next_process_step);
          case Wait(tran)   :
            __.ended(End(__.fault().explain(_ -> _.e_input_parser_waiting_on_an_unitialized_process())));
          case Hold(held)   :
            __.belay(held.convert(
              (next_stderr) -> {
                stderr = next_stderr;
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
        __.log().debug(_ -> _.pure(stdin));
        return switch(stdin){
          case Wait(fn)             : 
            __.ended(End(__.fault().explain(_ -> _.e_input_parser_waiting_on_an_unitialized_process())));
          case Emit(e,rest)         : 
            //Pass input request from Output to Process
            final next_proxy                = arw(PReqInput(e,false));
            __.log().debug(_ -> _.pure(next_proxy));
            stdin                       = rest;
            f(next_proxy);
          case Hold(ft)             :
            final status = Io_Process_Hung(1,haxe.Timer.stamp());
            __.belay(
              ft.convert(
                stdinI -> {
                  stdin = stdinI;
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
                stdin = stdin.provide(ok);
                switch(stdin){
                  case Emit(emit,next) : 
                    stdin = next;
                    f(arw(PReqInput(emit,false)));
                  case Wait(wait) :
                    f(arw(PReqTouch));
                  case Hold(held) : 
                    __.belay(held.convert(x -> {
                        stdin = x;
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
                stderr = stderr.provide(no);
                return switch(stderr){
                  case Emit(o,next) : 
                    final next_process_step = arw(PReqInput(o,true));
                    stderr  = next;
                    f(next_process_step);
                  case Wait(tran)   :
                    f(arw(PReqTouch));
                  case Hold(held)   :
                    __.belay(held.convert(
                      (next_stderr) -> {
                        stderr = next_stderr;
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
    return f(process);
  }
}
abstract Processor<R>(ProcessorCls<R>) from ProcessorCls<R>{
  public function new(self) this = self;
  static public function lift<R>(self:ProcessorCls<R>):Processor<R> return new Processor(self);

  static public function make(proc,stdin,stderr,hung){
    return lift(new ProcessorCls(proc,stdin,stderr,hung));
  }
  static public function make0(proc){
    return make(
      proc,
      InputParser.unit(),
      InputParser.unit().map_r(
        (parse_result:ParseResult<InputResponse,Bytes>) -> parse_result.map(
          bytes   -> E_Process_Raw(bytes)
        )
      ),
      (num_calls,?last_timestamp) -> None
    );
  }
  @:to public function toOutlet(){
    return this.reply();
  }
  public function prj():ProcessorCls<R> return this;
  private var self(get,never):Processor<R>;
  private function get_self():Processor<R> return lift(this);
}