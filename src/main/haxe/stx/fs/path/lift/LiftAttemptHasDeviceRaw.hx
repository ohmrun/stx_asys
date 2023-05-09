package stx.fs.path.lift;


class LiftAttemptHasDeviceRaw{
  #if (sys || nodejs)
  static public function toTrack(self:Attempt<HasDevice,Raw,PathFailure>){
    return self.attempt(Raw._.toTrack);
  }
  static public function toDirectory(self:Attempt<HasDevice,Raw,PathFailure>){
    return self.attempt(Raw._.toDirectory);
  }
  static public function toJourney(self:Attempt<HasDevice,Raw,PathFailure>){
    return self.attempt(Raw._.toJourney);
  }
  static public function toAttachment(self:Attempt<HasDevice,Raw,PathFailure>){
    return self.attempt(Raw._.toAttachment);
  }
  static public function toArchive(self:Attempt<HasDevice,Raw,PathFailure>){
    return self.attempt(Raw._.toArchive);
  }
  #end
}
