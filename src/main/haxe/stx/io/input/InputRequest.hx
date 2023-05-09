package stx.io.input;

/**
 * Represents a request for input.
 */
enum InputRequestSum{
  /**
    Request State
  **/
  IReqState;
  /**
    Calls readAll under the hood, so won't return until exit.
  **/
  IReqTotal(?buffer_size:Int);
  /**
    Request Typed Value
  **/
  IReqValue(bs:ByteSize);
  /**
    Request Bytes
  **/
  IReqBytes(pos:Int,len:Int);
  IReqClose;
}
abstract InputRequest(InputRequestSum) from InputRequestSum to InputRequestSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:InputRequestSum):InputRequest return new InputRequest(self);
  
  @:from static public function fromIReqValue(bs:ByteSize):InputRequest{
    return lift(IReqValue(bs));
  }
  

  public function prj():InputRequestSum return this;
  private var self(get,never):InputRequest;
  private function get_self():InputRequest return lift(this);
}