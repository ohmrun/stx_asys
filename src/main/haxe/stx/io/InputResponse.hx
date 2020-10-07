package stx.io;

enum InputResponse{
  IResValue(p:Packet);
  IResBytes(b:Bytes);
  IResSpent;
}