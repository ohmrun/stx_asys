package sys.stx.asys;

class Volume implements VolumeApi{
  final sep : Separator;
  public function new(sep){
    this.sep = sep;
  }
  public function index(dir:Directory):Produce<Array<String>,FsFailure>{
    return Produce.fromFunXR(
      FileSystem.readDirectory.bind(dir.canonical(sep))
    ).errata(
      e -> e.fault().of(E_Fs_CannotReadDirectory)
    );
  }
  /** A Coroutine to read archive. **/
  @unimplemented
  public function read(archive:Archive,?binary:Bool=false):Produce<FileInput,FsFailure>{
    return throw UNIMPLEMENTED;
  }
  /** A Coroutine to edit archive. **/
  @unimplemented
  public function edit(archive:Archive,?binary:Bool=false):Produce<FileOutput,FsFailure>{
    return throw UNIMPLEMENTED;
  }
  @unimplemented
  public function meta(archive:Address):Produce<Stat,FsFailure>{
    return throw UNIMPLEMENTED;
  }
  @unimplemented
  public function is_directory(self:Address):Produce<Bool,FsFailure>{
    return throw UNIMPLEMENTED;
  }
}