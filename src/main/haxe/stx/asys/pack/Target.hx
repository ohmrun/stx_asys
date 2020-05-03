package stx.asys.pack;

import stx.asys.head.data.Target in TargetT;

abstract Target(TargetT) from TargetT to TargetT{
  public function new(self) this = self;
  static public function lift(self:TargetT):Target return new Target(self);
  

  
  public function canonical(){
    return Targets.canonical(this);
  }
  public function prj():TargetT return this;
  private var self(get,never):Target;
  private function get_self():Target return lift(this);
}