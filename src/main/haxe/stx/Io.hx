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
typedef ProcessRequest      = stx.io.process.ProcessRequest;
typedef ProcessResponse     = stx.io.process.ProcessResponse;
typedef ProcessState        = stx.io.process.ProcessState;
typedef ProcessFailure      = stx.fail.ProcessFailure;