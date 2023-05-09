package sys.stx.alias;

#if (sys || nodejs)
typedef StdFile = sys.io.File;
#end