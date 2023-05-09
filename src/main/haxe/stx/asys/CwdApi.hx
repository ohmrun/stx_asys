package stx.asys;

interface CwdApi{
  public function pop():Attempt<HasDevice,Directory,FsFailure>;
  public function put(str:Directory):Command<HasDevice,FsFailure>;
}
