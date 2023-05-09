package stx.fs;

@:enum abstract Separator(String) to String{
  var WinSeparator   = "\\\\";
  var PosixSeparator = "/";
  
  @:to public function toString():String{
    return Std.string(this);
  }
  
  public function new(distro){
    #if sys
      this = distro == Windows ? WinSeparator : PosixSeparator;
    #else
      this = PosixSeparator;
    #end
  }
}
