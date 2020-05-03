package stx.asys;

class Module extends Clazz{
  public function local():HasDevice{
    return { device : new Device(new Distro()) };
  }
}