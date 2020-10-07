package stx.io.proxy;

import haxe.ds.Option;
import haxe.io.Eof;
import tink.core.Outcome;
import tink.CoreApi;
import stx.Proxy;
import stx.proxy.data.Proxy;

import stx.io.Peck;
import stx.io.simplex.Input;
import stx.io.simplex.Output;
import stx.io.Iota;
import sys.io.Process in HProcess;

import stx.Proxy;

typedef ProcessProxy = Proxy<Noise,Command,Command,Channel,Option<ProcessError>>;

enum Channel{
  ERR(v:Iota);
  OPT(v:Iota);
}
enum ProcessErrorCode{
  EOF;
  ErrorInProcess;
}
class ProcessError extends TypedError<ProcessErrorCode>{
  public function new(code,msg,data){
    super(code,msg);
    this.data = data;
  }
}
enum Command{
  Pull(t:Peck,?errs:Bool);
  Push(v:Value);
}
class Process{
  static public function apply(command:String,?args:Array<String>):Command->ProcessProxy{
    var proc = new HProcess(command,args = args == null ? [] : args);
    var errs : haxe.io.Input   = proc.stderr;
    var outs : haxe.io.Input   = proc.stdout;
    var ins  : haxe.io.Output  = proc.stdin;

    var proc : Command -> ProcessProxy = null;
    return proc = function(c:Command){
      trace(c);
      return switch(c){
        case Pull(t,ers):
          var v = null;
          var e = null;

          try{
            if(ers){
                v = ERR(Input.pull(errs,t));
            }else{
                v = OPT(Input.pull(outs,t));
            }
          }catch(err:ProcessError){
            e = err;
          }catch(err:Eof){
            e = new ProcessError(500,Std.string(err),EOF);
          }catch(err:Dynamic){
            trace(err);
            e = new ProcessError(500,err,ErrorInProcess);
          }
          if(e != null){
            switch(e.data){
              case EOF  : Ended(None);
              default   : Ended(Some(e));
            }
          }else{
            Yield(v, proc);
          }

        case Push(v):
          Later(Output.push(ins,v).map(
            function(o:Outcome<Noise,Error>){
              return switch(o){
                case Failure(e) : Ended(e);
                case Success(v) : Await(Noise,proc);
              }
            }
          ));
      }
    }
  }
}
