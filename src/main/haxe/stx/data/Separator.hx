package asys.data;

@:enum abstract Separator(String) from String{
  var WinSeparator   = "\\";
  var PosixSeparator = "/";
  
  public function toString():String{
    return Std.string(this);
  }
}
