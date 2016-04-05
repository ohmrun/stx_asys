package stx.sys.io;

import stx.pump.io.Input;
import stx.pump.io.Output;

import tink.CoreApi;
import stx.Proxy;
import stx.proxy.data.Proxy;

import sys.io.Process in HProcess;

import asys.io.process.Type;
import asys.io.process.Value;

import stx.Proxy;

typedef ProcessProxy = Proxy<Noise,Command,Command,Value,Error>;

enum Command{
  Pull(t:Type);
  Push(v:Value);
}
class Process{
  static public function create(command:String,?args:Array<String>):Command->ProcessProxy{
    var proc = new HProcess(command,args = args == null ? [] : args);
    var errs  = proc.stderr;
    var outs : haxe.io.Input   = proc.stdout;
    var ins  : haxe.io.Output  = proc.stdin;

    var proc : Command -> ProcessProxy = null;
    return proc = function(c:Command){
      return switch(c){
        case Pull(t):
          var v = null;
          var e = null;

          try{
            v = Input.pull(outs,t);
          }catch(err:Error){
            e = err;
          }catch(err:Dynamic){
            e = new Error(500,err);
          }
          if(e != null){
            Ended(e);
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
