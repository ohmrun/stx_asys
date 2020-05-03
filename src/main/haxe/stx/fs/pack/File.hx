package stx.fs.pack;

class File extends Clazz{
  public function read(path:String,?binary = false):Proceed<FileInput,FSFailure>{
    return () -> {
      var out = null;
      try{
        out = __.success(StdFile.read(path,binary));
      }catch(e:Dynamic){
        out = __.failure(__.fault().of(FileUnreadable(e)));
      }  
      return out;
    }
  }
  public function exists(str:String):Proceed<Bool,FSFailure>{
    return () -> {
      var out = null;
      try{
        out = __.success(FileSystem.exists(str));
      }catch(e:Dynamic){
        out = __.failure(__.fault().of(UnknownFSError(e)));
      }  
      return out;
    };
  }
  public function is_dir(str:String):Proceed<Bool,FSFailure>{
    return () -> {
      var out = null;
      try{
        out = __.success(FileSystem.isDirectory(str));
      }catch(e:Dynamic){
        out = __.failure(__.fault().of(UnknownFSError(e)));
      }  
      return out;
    };
  }
  public function put(archive:Archive,data:String):Command<HasDevice,FSFailure>{
    return (env:HasDevice) -> {
      var out = Report.unit();
      try{
        StdFile.saveContent(archive.canonical(env.device.sep),data);
      }catch(e:Dynamic){
        out = Report.pure(__.fault().of(UnknownFSError(e)));
      }
      return out;
    }
  }
}