package stx.asys.pack;

abstract WorkingDirectory(Directory) from Directory to Directory{
  public function new(self){
    this = self;
  }
  /*
  public function navigate(path:FilePath):Proceed<FilePath,PathFailure>{
    return () -> {
      return switch(path.head){
        case FPRoot(_):
          End(
            __.fault().because("can't commit absolute path to absolute path")
          );
        default :
          function fn(next,memo:Array<String>){
            return switch (next){
              case FPFrom       : memo.take(memo.length-1);
              case FPInto(name) : memo.snoc(name);
            }
          }
          var new_body = this.body.map(FPInto).concat(path.body).fold(fn,[].ds());
          Val(({
            head : path.head,
            body : new_body.map(FPInto),
            tail : path.tail
        }:FilePath));
      }
    }
  }*/
}