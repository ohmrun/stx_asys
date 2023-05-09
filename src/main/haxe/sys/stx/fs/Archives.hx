package sys.stx.fs;

class Archives{
  static public function val(self:Archive):Attempt<HasDevice,String,FsFailure>{
    return ((env:HasDevice) -> {
      var canonical = self.canonical(env.device.sep);
      return  try{
      __.accept(StdFile.getContent(canonical));
      }catch(e:Dynamic){
        //__.log().trace(e);
        if(Std.string(e) == '[file_contents,$canonical]'){
          __.reject(__.fault().of(E_Fs_FileNotFound(self)));
        }else if(Std.string(e) == 'Could not read file $canonical'){
          __.reject(__.fault().of(E_Fs_FileNotFound(self)));
        }else{
          __.reject(__.fault().of(E_Fs_UnknownFSError(e)));
        }
      }
    });
  }

  static public function exists(self:Archive):Attempt<HasDevice,Bool,FsFailure>{
    return (env:HasDevice) -> {
      var canonical = self.canonical(env.device.sep);
      var exists    = FileSystem.exists(canonical);
      return __.accept(exists);
    }
  }
  static public function update(self:Archive,data:String):Command<HasDevice,FsFailure>{
    return __.command((env:HasDevice) -> {
      var out = None;
      try{
        StdFile.saveContent(self.canonical(env.device.sep),data);
      }catch(e:Dynamic){
        out = Some(__.fault().of(E_Fs_UnknownFSError(e)));
      }
      return out;
    });
  }
  static public function upsert(self:Archive,data:String){
    var lhs = self.directory().inject();
    var rhs = self.update(data);
    var two = lhs.and(rhs);
    return two;
  }
}