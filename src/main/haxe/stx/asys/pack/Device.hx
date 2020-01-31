package stx.asys.pack;

import stx.asys.fs.type.Volume in VolumeI;

class Device implements stx.asys.type.Device{
  public function new(distro){
    this.distro   = distro;
    this.env      = new Env();
    this.volume   = new Volume();
  }
  public var distro(default,null):Distro;
  public var env(default,null):Env;
  public var volume(default,null):VolumeI;
}