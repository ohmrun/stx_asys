package asys;

import asys.data.Separator in TSeparator;

abstract Seperator(TSeparator) from TSeparator{
  public function new(?self){
    if(self == null){
      if (Sys.systemName() == "Windows"){
        self = TSeparator.WinSeparator;
      }else{
        self = TSeparator.PosixSeparator;
      }
    }
    this = self;
  }
  public function toString():String{
    return Std.string(this);
  }
}