package stx.fs;

@:enum abstract Separator(String) to String{
  var WinSeparator   = "\\\\";
  var PosixSeparator = "/";
  
  @:to public function toString():String{
    return Std.string(this);
  }
  
  public function new(){
    #if sys
      this = new Distro() == Windows ? WinSeparator : PosixSeparator;
    #else
      this = PosixSeparator;
    #end
  }
  static public function unit(){
    return new Separator();
  }
}
