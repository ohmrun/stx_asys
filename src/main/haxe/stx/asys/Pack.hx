package stx.asys;

interface ASysApi{
  public function sleep(float:Float):Bang;
}

typedef StdFile           = sys.io.File;

typedef ASysFailure        = stx.asys.pack.ASysFailure;

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

typedef Target            = stx.asys.pack.Target;

typedef Devices           = stx.asys.head.Devices;
typedef Targets           = stx.asys.body.Targets;




class Pack{
  
}
class LiftAsys{
  static public function asys(__:Wildcard){
    return new stx.asys.Module();
  }
  
}
class LiftDrive{
  static public function canonical(drive:Drive,env:HasDevice):String{
    var sep = '${env.device.sep}';
    return switch(drive){
      case Some(name)       : 'name$sep';
      case None             :  sep;
    }
  }
}