package stx.io;

enum InputRequest{
  //IReqStart;
  IReqValue(bs:ByteSize);
  IReqBytes(pos:Int,len:Int);
  IReqClose;
}