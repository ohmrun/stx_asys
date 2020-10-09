package stx.fs.pack;

import sys.io.FileInput;
import sys.io.FileOutput;

class File extends Clazz{
  public function read(path:String,?binary = false):Produce<FileInput,FsFailure>{
    return () -> {
      var out = null;
      try{
        out = __.accept(StdFile.read(path,binary));
      }catch(e:Dynamic){
        out = __.reject(__.fault().of(FileUnreadable(e)));
      }  
      return out;
    }
  }
  public function exists(str:String):Produce<Bool,FsFailure>{
    return () -> {
      var out = null;
      try{
        out = __.accept(FileSystem.exists(str));
      }catch(e:Dynamic){
        out = __.reject(__.fault().of(UnknownFSError(e)));
      }  
      return out;
    };
  }
  public function is_dir(str:String):Produce<Bool,FsFailure>{
    return () -> {
      var out = null;
      try{
        out = __.accept(FileSystem.isDirectory(str));
      }catch(e:Dynamic){
        out = __.reject(__.fault().of(UnknownFSError(e)));
      }  
      return out;
    };
  }
  public function put(archive:Archive,data:String):Command<HasDevice,FsFailure>{
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