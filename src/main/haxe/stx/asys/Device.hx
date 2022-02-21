package stx.asys;

interface DeviceApi{
  public final distro     : Distro;
  public final sep        : Separator;
  public final volume     : VolumeApi;
  public final shell      : Shell;
  public final env        : Env;
}

class Device implements DeviceApi{
  static public function make(distro,sep,volume,shell,env):Device{
    return new Device(
      distro,
      sep,
      volume,
      shell,
      env
    );
  }
  static public function make0(distro:Distro):Device{
    final sep = distro.is_windows() ? WinSeparator : PosixSeparator;
    return make(
      distro,
      sep,
      new Volume(sep),
      new Shell(),
      new Env()
    );
  }
  private function new(distro,sep,volume,shell,env){
    this.distro = distro;
    this.sep    = sep;
    this.volume = volume;
    this.shell  = shell;
    this.env    = env;
  }
  public final distro     : Distro;
  public final sep        : Separator;
  public final volume     : VolumeApi;
  public final shell      : Shell;

  public final env        : Env;

  @:to public function toHasDevice():HasDevice{
    return { device : this }
  }
  static public function local():HasDevice{
    return { device : Device.make0(new Distro()) };
  }
  static public function windows():HasDevice{
    return { device : Device.make0(Windows) };
  }
  static public function linux():HasDevice{
    return { device : Device.make0(Linux) };
  }
}