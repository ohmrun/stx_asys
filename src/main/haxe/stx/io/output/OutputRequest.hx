package stx.io.output;

enum OutputRequestSum{
  OReqValue(packet:Packet);
  OReqBytes(bytes:Bytes);
  OReqClose;
}
abstract OutputRequest(OutputRequestSum) from OutputRequestSum to OutputRequestSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:OutputRequestSum):OutputRequest return new OutputRequest(self);

  @:from static public function fromPacket(self:Packet):OutputRequest{
    return OReqValue(self);
  }
  public function prj():OutputRequestSum return this;
  private var self(get,never):OutputRequest;
  private function get_self():OutputRequest return lift(this);
}