package stx;

class LiftASys{
  static public function asys(__:Wildcard){
    return new stx.asys.Module();
  } 
  static public function localhost(__:Wildcard):Device{
    return new Device(new Distro());
  }
}
typedef ASysApi           = stx.asys.pack.ASys.ASysApi; 
typedef ASys              = stx.asys.pack.ASys; 

typedef ByteSize          = stx.asys.pack.ByteSize;
typedef Packet            = stx.asys.pack.Packet;
typedef Distro            = stx.asys.pack.Distro;
typedef EnvApi            = stx.asys.pack.Env.EnvApi;
typedef Env               = stx.asys.pack.Env;
typedef Cwd               = stx.asys.pack.Cwd;
typedef Device            = stx.asys.pack.Device;
typedef LocalHost         = stx.asys.pack.LocalHost;

typedef WorkingDirectory  = stx.asys.pack.WorkingDirectory;
typedef HasDevice         = stx.asys.pack.HasDevice;

typedef Shell             = stx.asys.pack.Shell;

typedef TargetSum         = stx.asys.pack.Target.TargetSum;
typedef Target            = stx.asys.pack.Target;
