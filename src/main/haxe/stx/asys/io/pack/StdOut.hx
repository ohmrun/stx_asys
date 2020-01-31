package stx.asys.io.pack;

abstract StdOut(StdOutput) from StdOutput{
  public function new(self){
    this = self;
  }
  public function apply(type:Packet):EIO<IOFailure>{
    return StdOuts.push(this,type);
  }
}