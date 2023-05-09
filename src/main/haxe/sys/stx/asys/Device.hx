package sys.stx.asys;
class Device implements DeviceApi{
  @:noUsing static public function make(distro,sep,system,shell):Device{
    return new Device(
      distro,
      sep,
      system,
      shell
    );
  }
  @:noUsing static public function make0(distro:Distro):Device{
    final sep = distro.is_windows() ? WinSeparator : PosixSeparator;
    return make(
      distro,
      sep,
      new System(sep),
      new Shell()
    );
  }
  @:deprecated
  @:noUsing static public function make1(?distro,?sep,?volume,?shell,?env){
    final distro  = __.option(distro).defv(new Distro()); 
    final sep     = __.option(sep).defv(distro.is_windows() ? WinSeparator : PosixSeparator);
    return make(
      distro,
      sep,
      __.option(volume).defv(volume),
      __.option(shell).defv(new Shell()),
      __.option(env).defv(new Env())
    );
  }
  static public function unit(){
    return make0(new Distro());
  }
  private function new(distro,sep,system,shell){
    this.distro = distro;
    this.sep    = sep;
    this.system = system;
    this.shell  = shell;
  }
  public final distro       : Distro;
  public final sep          : Separator;
  public final system       : SystemApi;
  public final shell        : Shell;

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
#end