package stx.asys.core;

class EUnknownDistro extends Digest{
  public function new(name){
    super('01FRQ6VSNTCEKZYDAZG4G560KP','No distro named $name');
  }
}
/**
  This relates to both the Input `Coroutine` being in an a `Wait` state, and the Process `Server requiring a request. ie `Yield(state,fn)`.
**/
class EInputParserWaitingOnAnUninitializedProcess extends Digest{
  public function new(){
    super("01FS6V9R64369F8T5WFZ3S7VRS","Process is unitialized and the Input Parser has requested no input");
  }
}
class EInputUnexpectedEnd extends Digest{
  public function new(){
    super("01FS95PFFZX8Y6MX1J0JEXAT4Y","Input ended unexpectedly");
  }
}
class EInputUnexpectedResponse extends Digest{
  public function new(){
    super("01FS95TMG8KDWWA98MEVW74C37","Input ended unexpectedly");
  }
}
class Errors{
  static public function e_unknown_distro(digests:Digests,name):Digest{
    return new EUnknownDistro(name);
  }
  static public function e_input_parser_waiting_on_an_unitialized_process(digests:Digests){
    return new EInputParserWaitingOnAnUninitializedProcess();
  }
  static public function e_input_unexpected_end(digests:Digests){
    return new EInputUnexpectedEnd();
  }
  static public function e_input_unexpected_response(digests:Digests){
    return new EInputUnexpectedResponse();
  }
}