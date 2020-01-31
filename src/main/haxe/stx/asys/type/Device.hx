package stx.asys.type;

import stx.asys.fs.type.Volume;

interface Device{
  public var distro(default,null)     : Distro;
  public var env(default,null)        : Env;
  public var volume(default,null)     : Volume;
}