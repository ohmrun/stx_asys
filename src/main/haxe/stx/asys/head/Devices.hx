package stx.asys.head;

class Devices{
  static public function local():HasDevice{
    return { device : new Device(new Distro()) };
  }
  static public function windows():HasDevice{
    return { device : new Device(Windows) };
  }
  static public function linux():HasDevice{
    return { device : new Device(Linux) };
  }
}