package stx;

import stx.fail.PathParseFailure;
import stx.fail.ParseFailure;

typedef FsFailure       = stx.fail.FsFailure;
typedef FsFailureSum    = stx.fail.FsFailure.FsFailureSum;

typedef FsString        = stx.fs.pack.FsString;

#if (sys || nodejs)
  typedef File          = stx.fs.pack.File;
  typedef Volume        = stx.fs.pack.Volume;
  typedef VolumeApi     = stx.fs.pack.Volume.VolumeApi;
#end
  

class LiftParseErrorInfoToPathParseFailure{
  static public function toPathParseFailure(e:ParseFailure):PathParseFailure{
    return E_PathParse_ParseErrorInfo(e);
  } 
}