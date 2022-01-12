package stx.io;

enum InputResponse{
  IResValue(packet:Packet);
  IResBytes(b:Bytes,?type:Option<ByteSize>);
  IResSpent;
  IResState(state:InputState);
}
//type:Option<ByteSize>
// typedef PacketDef = {
//   final data : Bytes;
//   final type : Option<ByteSize>;
// }