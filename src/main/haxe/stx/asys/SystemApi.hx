package stx.asys;

interface SystemApi{
  /**
    `VolumeApi`
  **/
  public final volume : VolumeApi;
  /**
    `ShellApi`
  **/
  public final shell  : ShellApi;

  public function sleep(float:Float):Future<Nada>;
}