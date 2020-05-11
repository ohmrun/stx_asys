package stx.io.pack;

enum InputRequest{
  IReqValue(bs:ByteSize);
  IReqBytes(pos:Int,len:Int);
  IReqClose;
}