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

typedef OutputRequestSum    = stx.io.output.OutputRequest.OutputRequestSum;
typedef OutputRequest       = stx.io.output.OutputRequest;


typedef StdOut              = stx.io.StdOut;
typedef StdIn               = stx.io.StdIn;

typedef InputResponse       = stx.io.input.InputResponse;

typedef InputRequestSum     = stx.io.input.InputRequest.InputRequestSum;
typedef InputRequest        = stx.io.input.InputRequest;

typedef InputState          = stx.io.input.InputState;
typedef InputStateSum       = stx.io.input.InputState.InputStateSum;


typedef IoFailure           = stx.fail.IoFailure;
typedef IoFailureSum        = stx.fail.IoFailure.IoFailureSum;

typedef ExitCodeDef         = stx.io.process.ExitCode.ExitCodeDef;
typedef ExitCode            = stx.io.process.ExitCode;

typedef LiftInputResponse   = stx.io.lift.LiftInputResponse;
