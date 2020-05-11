package stx.io.pack;

enum InputResponse{
  IResValue(p:Packet);
  IResBytes(b:Bytes);
  IResSpent;
}