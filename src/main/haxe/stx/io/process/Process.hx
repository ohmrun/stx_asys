package stx.io.process;

import stx.io.StdIn  in AsysStdIn;
import stx.io.StdOut in AsysStdOut;


typedef ProcessDef = ServerDef<ProcessRequest,ProcessResponse,Noise,ProcessFailure>;


class ProcessCls{
  private var proc                  : sys.io.Process;
  private var stdin                 : Output;
  private var stdout                : Input;
  private var stderr                : Input;

  public var state(default,null)    : ProcessState;

  @:noUsing static public function make0(command:Cluster<String>,?detached:Bool):ProcessCls{
    final proc                        = new sys.io.Process(command.head().fudge(), Std.downcast(command.tail(),Array),detached);
    final ins   : Output              = AsysStdOut.lift(proc.stdin).reply();
    final outs  : Input               = AsysStdIn.lift(proc.stdout).reply();
    final errs  : Input               = AsysStdIn.lift(proc.stderr).reply();    
    return new ProcessCls(proc, ins, outs, errs);
  }
  public function new(proc:sys.io.Process,stdin:Output,stdout:Input,stderr:Input,?state:ProcessState){
    this.proc   = proc;
    this.stdin  = stdin;
    this.stdout = stdout;
    this.stderr = stderr; 
    this.state  = __.option(state).defv(ProcessState.make(Io_Process_Init));
  }
  private function get_state(?block = false){
    this.stdout = this.stdout.mandate(
      IReqState,
      (res) -> {
        switch(res){
          case Accept(IResState(s)) : 
            this.state = this.state.with_stdout(s);
          case Reject(err)          : 
            this.state = err.data.fold(
              (declination) -> declination.fold(
                (e) -> this.state.with_stdout(Io_Input_Error(e)),
                (d) -> this.state.with_stdout(Io_Input_Error(E_Io_Digest(d)))
              ),
              ()  -> this.state.with_stdout(Io_Input_Error(E_Io_UnsupportedValue))
            );
          default                   : 
            this.state = this.state.with_stdout(Io_Input_Error(E_Io_UnsupportedValue));
        }
      }
    );
    this.stderr  = this.stderr.mandate(
      IReqState,
      (res) -> {
        switch(res){
          case Accept(IResState(s)) : 
            this.state = this.state.with_stderr(s);
          case Reject(err)          : 
            this.state = err.data.fold(
              (declination) -> declination.fold(
                (e) -> this.state.with_stderr(Io_Input_Error(e)),
                (d) -> this.state.with_stderr(Io_Input_Error(E_Io_Digest(d)))
              ),
              ()  -> this.state.with_stderr(Io_Input_Error(E_Io_UnsupportedValue))
            );
          default                   : 
            this.state = this.state.with_stderr(Io_Input_Error(E_Io_UnsupportedValue));
        }
      }
    );
    this.state = this.state.with_exit_code(ExitCode.lift(proc.exitCode(block)));
  }
  public function reply():ProcessDef{
    return __.yield(
      PResState(this.state),
      function rec(req:ProcessRequest){
        return switch(this.state){
          case { status : ( Io_Process_Init | Io_Process_Open ) } :
            switch(req){
              case PReqTouch                : reply();
              case PReqState(block)         : 
                get_state(block);
                reply();
              case PReqInput(req,false)     : 
                final source = Future.trigger();
                this.stdout  = stdout.mandate(
                  req,
                  res -> res.fold(
                    ok -> source.trigger(__.yield(PResValue(Success(ok)),rec)),
                    no -> source.trigger(__.ended(End(no.errate(E_Process_Io))))
                  )
                );
                __.belay(Belay.fromFuture(() -> source.asFuture()));
              case PReqInput(req,true)      : 
                final source = Future.trigger();
                this.stderr  = stderr.mandate(
                  req,
                  res -> res.fold(
                    ok -> source.trigger(__.yield(PResValue(Failure(ok)),rec)),
                    no -> source.trigger(__.ended(End(no.errate(E_Process_Io))))
                  )
                );
                __.belay(Belay.fromFuture(() -> source.asFuture()));
              case PReqOutput(req)          : 
                this.stdin  = stdin.provide(req);
                reply();
            }
          case { status : x } :
            __.yield(PResState(this.state),rec);
        }
      }
    );
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
@:using(stx.io.process.Process.ProcessLift)
abstract Process(ProcessDef) from ProcessDef to ProcessDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ProcessDef):Process return new Process(self);

  public function prj():ProcessDef return this;
  private var self(get,never):Process;
  private function get_self():Process return lift(this);

  @:noUsing static public function make0(command:Cluster<String>,?detached:Bool):Process{
    return Process.lift(ProcessCls.make0(command,detached).reply());
  }
}