package sys.stx.asys;

class Device implements DeviceApi{
  @:noUsing static public function make(distro,sep,system,console):Device{
    return new Device(
      distro,
      sep,
      system,
      console
    );
  }
  @:noUsing static public function make0(distro:Distro):Device{
    final sep = distro.is_windows() ? WinSeparator : PosixSeparator;
    return make(
      distro,
      sep,
      Some((new System(sep):SystemApi)),
      new Console()
    );
  }
  @:deprecated
  @:noUsing static public function make1(?distro,?sep,?system,?console){
    final distro  = __.option(distro).defv(__.asys().Distro().unit()); 
    final sep     = __.option(sep).defv(distro.is_windows() ? WinSeparator : PosixSeparator);
    return make(
      distro,
      sep,
      __.option(system).defv(system),
      __.option(console).defv(new Console())
    );
  }

  private function new(distro,sep,system,console){
    this.distro     = distro;
    this.sep        = sep;
    this.system     = system;
    this.console    = console;
  }
  public final distro       : Distro;
  public final sep          : Separator;
  public final system       : Option<SystemApi>;
  public final console      : ConsoleApi;

  @:to public function toHasDevice():HasDevice{
    return { device : this }
  }
  static public function windows():HasDevice{
    return { device : Device.make0(Windows) };
  }
  static public function linux():HasDevice{
    return { device : Device.make0(Linux) };
  }
}