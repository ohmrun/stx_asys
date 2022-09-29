package stx.io.lift;

class LiftInputResponse{
  static public function toOutputRequest(self:InputResponse):Option<OutputRequest>{
    return switch(self){
      case IResValue(p) : Some(OReqValue(p));
      case IResBytes(b) : Some(OReqBytes(b));
      case IResStarved    : Some(OReqClose);
      case IResState(_) : None;
    }
  }
}