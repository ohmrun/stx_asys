package stx;

typedef FsFailure       = stx.fail.FsFailure;
typedef FsFailureSum    = stx.fail.FsFailure.FsFailureSum;

typedef FsString        = stx.fs.pack.FsString;

#if (sys || hxnodejs)
  typedef File          = stx.fs.pack.File;
  typedef Volume        = stx.fs.pack.Volume;
  typedef VolumeApi     = stx.fs.pack.Volume.VolumeApi;
#end
  

class LiftParseErrorInfoToPathParseFailure{
  static public function toPathParseFailure(e:stx.parse.core.ParseError):PathParseFailure{
    return E_PathParse_ParseErrorInfo(e);
  } 
}