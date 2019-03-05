package stx.asys.fs.pack;

import stx.asys.fs.head.data.Separator in SeparatorT;

@:forward abstract Separator(SeparatorT) from SeparatorT{
  public function new(?self){
    if(self == null){
      if (Sys.systemName() == "Windows"){
        self = SeparatorT.WinSeparator;
      }else{
        self = SeparatorT.PosixSeparator;
      }
    }
    this = self;
  }
  public function toString():String{
    return Std.string(this);
  }
}