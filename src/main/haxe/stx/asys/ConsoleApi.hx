package stx.asys;

interface ConsoleApi{
  public function print(v:Dynamic):Future<Nada>;
  public function println(v:Dynamic):Future<Nada>;
}