package stx.asys.fs.pack;

class File extends Clazz{
  public function read(path:StdPath,?binary):IO<FileInput,FSFailure>{
    var err = IOs.fromChunk.fn().then(
      (io) -> io.errata((err) -> err.fault().of(FileUnreadable(err)))
    );
    var fn  = StdFile.read.bind(path.toString(),binary).fnX();
    var f0  = fn.then(err);
    var f1  = IOs.fromUnaryConstructor(f0);
    return f1;
  }
  public function exists(str:String):IO<Bool,FSFailure>{
    var out = FileSystem.exists.bind(str).fnX()
      .then(
        IOs.fromChunk.fn().then(
          io -> io.errata((err) -> err.fault().of(FileUnreadable(err)))
        )
      );
    return IOs.fromUnaryConstructor(out);
  }
  public function is_dir(str:String):IO<Bool,FSFailure>{
    return FileSystem.isDirectory.bind(str)
      .fnX()
      .then(
        IOs.fromChunk.fn().then(
          (io) -> io.errata(
            (err) -> err.fault().of(UnknownFSError)
          )
        )
      ).broker(
        (F) -> IOs.fromUnaryConstructor
      );
  }
}