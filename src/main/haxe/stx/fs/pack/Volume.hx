package stx.fs.pack;

interface VolumeApi{
  public function index(dir:Directory):Proceed<Array<String>,FSFailure>;
  public function parent(dir:Directory):Res<Directory,PathFailure>;

  public function read(archive:Archive,?binary : Bool = false):Proceed<FileInput,FSFailure>;
}

class Volume implements VolumeApi extends Clazz{
  private var sep : Separator;
  public function new(sep){
    super();
    this.sep = sep;
  }
  public function index(dir:Directory):Proceed<Array<String>,FSFailure>{
    return Proceed.fromFunXR(
      FileSystem.readDirectory.bind(dir.canonical(sep))
    ).errata(
      e -> e.fault().of(CannotReadDirectory)
    );
  }
  public function parent(dir:Directory):Res<Directory,PathFailure>{
    return (dir.track.length > 0).if_else(
      () -> __.success(Directory.make(dir.drive,new Track(dir.track.rdropn(1)))),
      () -> __.failure(__.fault().of(ReachedRoot))
    );
  }

  public function read(archive:Archive,?binary = false):Proceed<FileInput,FSFailure>{
    return () -> try{
      __.success(StdFile.read(archive.canonical(sep),binary));
    }catch(e:Dynamic){
      __.failure(__.fault().of(FileUnreadable(e)));
    }
  }
  // public function has(path:Path):Channel<Shell,Bool>{
  //   return ((env:Shell) -> {
      
  //   });
  // }
}
