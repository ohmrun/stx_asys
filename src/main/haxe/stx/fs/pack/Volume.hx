package stx.fs.pack;

interface VolumeApi{
  public function index(dir:Directory):Produce<Array<String>,FsFailure>;
  public function parent(dir:Directory):Res<Directory,PathFailure>;

  public function read(archive:Archive,?binary : Bool = false):Produce<FileInput,FsFailure>;
}

class Volume implements VolumeApi extends Clazz{
  private var sep : Separator;
  public function new(sep){
    super();
    this.sep = sep;
  }
  public function index(dir:Directory):Produce<Array<String>,FsFailure>{
    return Produce.fromFunXR(
      FileSystem.readDirectory.bind(dir.canonical(sep))
    ).errata(
      e -> e.fault().of(E_Fs_CannotReadDirectory)
    );
  }
  public function parent(dir:Directory):Res<Directory,PathFailure>{
    return (dir.track.length > 0).if_else(
      () -> __.accept(Directory.make(dir.drive,new Track(dir.track.rdropn(1)))),
      () -> __.reject(__.fault().of(E_Path_ReachedRoot))
    );
  }

  public function read(archive:Archive,?binary = false):Produce<FileInput,FsFailure>{
    return () -> try{
      __.accept(StdFile.read(archive.canonical(sep),binary));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_Fs_FileUnreadable(e)));
    }
  }
  public function write(archive:Archive,?binary = false):Produce<FileOutput,FsFailure>{
    return () -> try{
      __.accept(StdFile.write(archive.canonical(sep),binary));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_Fs_FileUnwriteable(e)));
    }
  }
  // public function has(path:Path):Channel<Shell,Bool>{
  //   return ((env:Shell) -> {
      
  //   });
  // }
}