package stx.fs;

interface VolumeApi{
  public function index(dir:Directory):Produce<Array<String>,FsFailure>;
  /**
    A Coroutine to read archive.
  **/
  public function read(archive:Archive,?binary:Bool=false):Produce<FileInput,FsFailure>;
  /**
    A Coroutine to edit archive.
  **/
  public function edit(archive:Archive,?binary:Bool=false):Produce<FileOutput,FsFailure>;
  
  public function meta(archive:Address):Produce<Stat,FsFailure>;

  public function is_directory(self:Address):Produce<Bool,FsFailure>;
}