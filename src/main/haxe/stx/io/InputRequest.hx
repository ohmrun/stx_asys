package stx.io;

enum InputRequestSum{
  //IReqStart;
  IReqState;
  IReqTotal(?buffer_size:Int);
  IReqValue(bs:ByteSize);
  IReqBytes(pos:Int,len:Int);
  IReqClose;
}
abstract InputRequest(InputRequestSum) from InputRequestSum to InputRequestSum{
  public function new(self) this = self;
  static public function lift(self:InputRequestSum):InputRequest return new InputRequest(self);
  
  @:from static public function fromIReqValue(bs:ByteSize):InputRequest{
    return lift(IReqValue(bs));
  }
  

  public function prj():InputRequestSum return this;
  private var self(get,never):InputRequest;
  private function get_self():InputRequest return lift(this);
}