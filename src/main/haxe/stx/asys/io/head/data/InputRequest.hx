package stx.asys.io.head.data;

enum InputRequest{
  IReqValue(bs:ByteSize);
  IReqBytes(pos:Int,len:Int);
}