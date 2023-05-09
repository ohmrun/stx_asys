package sys.stx.asys;

/**
  Default implementation of SystemApi to run on localhost.
**/
class System implements stx.asys.SystemApi extends Clazz{
  public function new(sep){
    super();
    this.volume = new sys.stx.asys.Volume(sep);
    this.shell  = new sys.stx.asys.Shell();
  }
  /**
    `VolumeApi`
  **/
  public final volume : VolumeApi;
  /**
    `ShellApi`
  **/
  public final shell  : ShellApi;
  public function sleep(t):Future<Nada>{
    return Future.irreversible(
      (cb) -> {
        std.Sys.sleep(t);
        cb(Nada);
      }
    );
  }

}