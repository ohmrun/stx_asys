package stx.io.pack;

import stx.io.pack.StdIn  in AsysStdIn;
import stx.io.pack.StdOut in AsysStdOut;

typedef ProcessDef = Server<InputRequest,InputResponse,Noise,IOFailure>;

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

      var is_error_condition          = false;
      try{
        errs.prj().readBytes(errs_buffer,0,1);
      }catch(e:Eof){
        is_error_condition            = true;
      }

      var outs_in = new Input(outs);
          
      return null;
    }; 
  }
}