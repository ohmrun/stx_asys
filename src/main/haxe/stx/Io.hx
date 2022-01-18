package stx;

class Io{}

#if (sys || nodejs)
typedef StdFile             = sys.io.File;
#end
typedef StdPath             = haxe.io.Path;

typedef StdInput            = haxe.io.Input;
typedef StdOutput           = haxe.io.Output;

typedef InputDef            = stx.io.Input.InputDef;
typedef Input               = stx.io.Input;
typedef OutputDef           = stx.io.Output.OutputDef;
typedef Output              = stx.io.Output;

typedef StdOut              = stx.io.StdOut;
typedef StdIn               = stx.io.StdIn;

typedef InputResponse       = stx.io.InputResponse;

typedef InputRequestSum     = stx.io.InputRequest.InputRequestSum;
typedef InputRequest        = stx.io.InputRequest;

typedef OutputRequestSum    = stx.io.OutputRequest.OutputRequestSum;
typedef OutputRequest       = stx.io.OutputRequest;

typedef IoFailure           = stx.io.IoFailure;

typedef Process             = stx.io.Process;
typedef ProcessDef          = stx.io.Process.ProcessDef;
typedef ProcessRequest      = stx.io.process.ProcessRequest;
typedef ProcessResponse     = stx.io.process.ProcessResponse;

typedef ProcessStateDef     = stx.io.process.ProcessState.ProcessStateDef;
typedef ProcessState        = stx.io.process.ProcessState;

typedef ProcessorCls<R>     = stx.io.Processor.ProcessorCls<R>;
typedef Processor<R>        = stx.io.Processor<R>;
//typedef ProcessorDef        = stx.io.Processor.ProcessorDef;

typedef ProcessStatusSum    = stx.io.process.ProcessStatus.ProcessStatusSum;
typedef ProcessStatus       = stx.io.process.ProcessStatus;
typedef ProcessFailure      = stx.fail.ProcessFailure;

typedef LiftInputResponse   = stx.io.lift.LiftInputResponse;

typedef InputState         = stx.io.InputState;
typedef InputStateSum      = stx.io.InputState.InputStateSum;