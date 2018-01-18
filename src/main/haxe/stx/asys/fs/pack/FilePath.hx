package asys;

import asys.impl.FilePath in CFilePath;

@:forward abstract FilePath(CFilePath) from CFilePath to CFilePath{
  public function new(self){
    this = self;
  }
  @:from static public function fromString(str:String):FilePath{
    return new CFilePath(str);
  }
}