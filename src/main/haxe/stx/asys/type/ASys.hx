package stx.asys.type;

interface ASys{
  public var device(get,null) : Device;
  private function get_device():Device;

  public function byte():UIO<Int>;
}