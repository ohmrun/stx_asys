package stx.asys.fs;

class Module{
  public function new(){}
  public function dir(){
    return new Dir();
  }
  public function file(){
    return new File();
  }
}