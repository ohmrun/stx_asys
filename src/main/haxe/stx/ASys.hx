package stx;

#if (sys || nodejs)
  class LiftASys{
    static public function asys(__:Wildcard){
      return new stx.asys.Module();
    } 
    static public function localhost(__:Wildcard):Device{
      return Device.make0(new Distro());
    }
  }
  typedef ASysApi           = stx.asys.ASys.ASysApi; 
  typedef ASys              = stx.asys.ASys; 

  typedef ASysFailure       = stx.fail.ASysFailure;
  typedef ASysFailureSum    = stx.fail.ASysFailure.ASysFailureSum;

  typedef Packet            = stx.asys.Packet;
  typedef Distro            = stx.asys.Distro;
  typedef EnvApi            = stx.asys.Env.EnvApi;
  typedef Env               = stx.asys.Env;
  typedef Cwd               = stx.asys.Cwd;
  typedef Device            = stx.asys.Device;
  typedef LocalHost         = stx.asys.LocalHost;
  typedef CharKind          = stx.asys.CharKind;

  typedef WorkingDirectory  = stx.asys.WorkingDirectory;
  typedef HasDevice         = stx.asys.HasDevice;
  typedef HasDeviceApi      = stx.asys.HasDeviceApi;

  typedef Shell             = stx.asys.Shell;
  typedef ShellApi          = stx.asys.Shell.ShellApi;
#end
