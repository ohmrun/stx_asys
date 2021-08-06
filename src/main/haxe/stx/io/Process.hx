package stx.io;

import stx.io.StdIn  in AsysStdIn;
import stx.io.StdOut in AsysStdOut;

typedef ProcessDef = Server<InputRequest,Either<InputResponse,InputRespon,Noise,IoFailure>;

abstract Process(ProcessDef) from ProcessDef{
  public function new(self){
    this = self;
  }
  static public function grow(command:Command){
    var fn = () ->  {
      final proc : StdProcess         = new StdProcess(command.name,command.args.prj());
      final errs : AsysStdIn          = proc.stderr;
      final outs : AsysStdIn          = proc.stdout;
      final ins  : AsysStdOut         = proc.stdin;

      var errs_buffer                 = new BytesBuffer().getBytes();
      var ins_buffer                  = new BytesBuffer().getBytes();

      var outs_in                     = new Input(outs);
      var return_value                = None;
      
      return Yield(
        IResReady,
        function rec(req:InputRequest){
          return switch (req){
            case IReqState            : 
            case IReqValue(bs)        :
            case IReqBytes(pos,len)   : 
            case IReqClose            : 
          }
        }        
      );
    }; 
  }
}