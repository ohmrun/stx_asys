package stx.asys.pack;

class Device implements stx.asys.type.Device{
  public function new(distro){
    this.distro   = distro;
    this.sep      = distro.is_windows() ? WinSeparator : PosixSeparator;
    this.env      = new Env();
    this.volume   = new Volume(sep);
    this.shell    = new Shell();
  }
  public var sep(default,null)        : Separator;

  public var distro(default,null)     : Distro;
  public var env(default,null)        : Env;
  public var volume(default,null)     : VolumeApi;
  public var shell(default,null)      : Shell;

  @:to public function toHasDevice():HasDevice{
    return { device : this }
  }
}