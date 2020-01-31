package stx.asys;

class Module extends Clazz{
  //by default set Device to LocalHost
  public function local():ASys{
    return new ASys();
  }
}