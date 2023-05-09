package sys.stx.alias;

#if (sys || nodejs)
typedef StdProcess = sys.io.Process;
#end