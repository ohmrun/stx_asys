package sys.stx.asys;

class User implements UserApi extends Clazz{
  public final device : Device;
  public function new(device){
    super();
    this.device = device;
  }
  public function home():Produce<Directory,ASysFailure>{
    var home   = null;
    var parser = 
      (str) ->  
        stx.fs.Path.parse(str)
          .provide((this:HasDevice))
          .flat_map(Raw._.toDirectory)
          .errate(x -> E_ASys_Fs(E_Fs_Path(x)));

    return if (this.device.distro.is_windows()) {
      home = Sys.getEnv("USERPROFILE");
      if (home == null) {
        var drive = Sys.getEnv("HOMEDRIVE");
        var path  = Sys.getEnv("HOMEPATH");
        if (drive != null && path != null)
          home = drive + path;
      }
      if (home == null)
        __.reject(__.fault().of(E_ASys_UndefinedHomePath));
      else
        parser(home);
      } else {
      home = std.Sys.getEnv("HOME");
      if (home == null)
        __.reject(__.fault().of(E_ASys_UndefinedHomePath));
      else{
        parser(home);
      }
    }
  }
}