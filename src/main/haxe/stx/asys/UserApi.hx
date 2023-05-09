package stx.asys;

interface UserApi{
  public function home():Produce<Directory,ASysFailure>;
}