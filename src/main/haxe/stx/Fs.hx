package stx;

import stx.fail.PathParseFailure;
import stx.fail.ParseFailure;

typedef FsFailure       = stx.fail.FsFailure;
typedef FsFailureSum    = stx.fail.FsFailure.FsFailureSum;

typedef FsString        = stx.fs.FsString;
typedef FileSeek        = stx.fs.FileSeek;

typedef VolumeApi       = stx.fs.VolumeApi;
typedef Separator       = stx.fs.Separator;
typedef Stat            = stx.fs.Stat;