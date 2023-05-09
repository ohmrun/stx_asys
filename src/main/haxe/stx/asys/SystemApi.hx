package stx.asys;

interface SystemApi{
  /**
    `VolumeApi`
  **/
  public final volume : VolumeApi;
  /**
    `ShellApi`
  **/
  public final Shell  : ShellApi;

  public function sleep(float:Float):Future<Noise>;
}