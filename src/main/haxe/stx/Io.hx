package stx;

class Io{}

#if (sys || nodejs)
typedef StdFile             = sys.io.File;
#end
typedef StdPath             = haxe.io.Path;

typedef StdInput            = haxe.io.Input;
typedef StdOutput           = haxe.io.Output;

typedef Input               = stx.io.Input;
typedef Output              = stx.io.Output;

typedef StdOut              = stx.io.StdOut;
typedef StdIn               = stx.io.StdIn;

typedef InputResponse       = stx.io.InputResponse;
typedef InputRequest        = stx.io.InputRequest;
typedef OutputRequest       = stx.io.OutputRequest;
typedef IoFailure           = stx.io.IoFailure;