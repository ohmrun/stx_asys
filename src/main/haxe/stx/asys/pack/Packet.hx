package stx.asys.pack;

typedef PacketDef = {
  var data : Primitive;
  var type : ByteSize;
}
@:forward abstract Packet(PacketDef) from PacketDef{
  @:from static public function fromString(str:String):Packet{
    return {
      data : PString(str),
      type : LINE
    };
  }
} 