package asys.nodejs;

import asys.ifs.File in IFile;

class File implements IFile{
  private var handle : Int;

  public function new(handle){
    this.handle = handle;
  }
}