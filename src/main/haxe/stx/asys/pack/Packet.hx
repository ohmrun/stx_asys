package stx.asys.pack;

typedef PacketDef = {
  var data : Primitive;
  var type : ByteSize;
}
@:forward abstract Packet(PacketDef) from PacketDef{
  
}