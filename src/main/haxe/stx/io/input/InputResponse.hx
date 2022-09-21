package stx.io.input;

enum InputResponse{
  IResValue(packet:Packet);
  IResBytes(b:Bytes,?type:Option<ByteSize>);
  IResSpent;
  IResState(state:InputState);
}