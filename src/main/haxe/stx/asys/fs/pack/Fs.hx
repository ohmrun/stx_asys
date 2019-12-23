package stx.asys.fs.pack;

import stx.asys.fs.head.data.Fs in FsI;

class Fs implements FsI{
  public function new(){

  }
  public var separator(default,null):Separator = PosixSeparator;
}
