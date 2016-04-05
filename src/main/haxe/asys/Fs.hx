package asys;

import sys.fs.Flags;
import asys.ifs.File;

import stx.async.Promise;

import tink.core.Error;
import tink.core.Future;

import stx.Path;

import haxe.ds.StringMap;

import sys.fs.Stats;

#if hxnodejs
  typedef Fs = js.node.Fs;
#else
  typedef Fs = sync.asys.Fs;
#end
