package stx.asys.io.pack;

abstract StdIn(StdInput) from StdInput{
  public function new(self){
    this = self;
  }
  public function apply(type:InputRequest):IO<InputResponse,IOFailure>{
    return StdIns.pull(this,type);
  }
  public function prj():StdInput{
    return this;
  }
}