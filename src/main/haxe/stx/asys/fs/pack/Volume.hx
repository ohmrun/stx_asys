package stx.asys.fs.pack;

class Volume implements stx.asys.fs.type.Volume{
  public function new(){

  }
  public var separator(default,null):Separator = PosixSeparator;
}
