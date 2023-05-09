package stx.asys;

interface ShellApi{
  public final env:EnvApi;
  public final cwd:CwdApi;

  public function stdin():Input;
  public function stderr():Output;
  public function stdout():Output;

  public function byte():Produce<Int,IoFailure>; 
}
