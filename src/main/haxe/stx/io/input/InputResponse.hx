package stx.io.input;

/**
 * Represents a response to an `InputRequest`.
 */
enum InputResponse{
  IResValue(packet:Packet);
  IResBytes(b:Bytes,?type:Option<ByteSize>);
  IResStarved;
  IResState(state:InputState);
}