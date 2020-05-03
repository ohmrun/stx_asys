package stx.io.pack;

abstract StdIn(StdInput) from StdInput{
  public function new(self){
    this = self;
  }
  public function apply(type:InputRequest):Proceed<InputResponse,IOFailure>{
    return StdIns.pull(this,type);
  }
  public function prj():StdInput{
    return this;
  }
}