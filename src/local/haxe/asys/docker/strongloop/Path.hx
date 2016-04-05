package asys.io;

using stx.Arrays;

abstract Path(String) from String to String{
  public function new(self){
    this = self;
  }
  public function add(path:String){
    return this.split(OS.local.seperator).filter(
      function(x){
        return x != '' && x != null;
      }
    ).join(OS.local.seperator);
  }
}
