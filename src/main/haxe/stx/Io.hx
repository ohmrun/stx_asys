package stx;


class Io{}

typedef StdFile             = sys.io.File;
typedef StdPath             = haxe.io.Path;

typedef StdInput            = haxe.io.Input;
typedef StdOutput           = haxe.io.Output;

//typedef Input              = stx.asys.io.pack.Input;
//typedef Output             = stx.asys.io.pack.Output;

typedef StdOut             = stx.io.pack.StdOut;
typedef StdIn              = stx.io.pack.StdIn;


//typedef Outputs            = stx.io.body.Outputs;
//typedef Inputs             = stx.io.body.Inputs;
typedef StdOuts            = stx.io.body.StdOuts;
typedef StdIns             = stx.io.body.StdIns;

typedef InputResponse       = stx.io.pack.InputResponse;
typedef InputRequest        = stx.io.pack.InputRequest;
typedef IOFailure           = stx.io.pack.IOFailure;