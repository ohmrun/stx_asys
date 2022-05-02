package stx.fs.path;

/**
  Represents the description of an absolute path from the root of the filesystem
  to a file handle.
**/
typedef ArchiveDef = {
  var drive : Drive;
  var track : Track;
  var entry : Entry;
}
@:using(stx.fs.path.Archive.ArchiveLift)
@:forward abstract Archive(ArchiveDef) from ArchiveDef to ArchiveDef{
  static public var _(default,never) = ArchiveLift;
  public function new(self) this = self;
  @:noUsing static public function lift(self:ArchiveDef):Archive return new Archive(self);
  @:noUsing static public function make(drive,track,entry) return lift({
    drive : drive,
    track : track,
    entry : entry
  });

  public function canonical(sep:Separator){
    var head  = this.drive.fold(
      (v) -> v,
      () -> ''
    );
    var body  = this.track.join(sep);
    var tail  = this.entry.canonical();
    return '$head${sep}$body${sep}$tail';
  }
  //attach
  public function update(data:String):Command<HasDevice,FsFailure> return _.update(self,data);
  public function upsert(data:String)                              return _.upsert(self,data);
  
  public function directory():Directory{
      return Directory.make(this.drive,this.track);
  }
  public function prj():ArchiveDef return this;
  private var self(get,never):Archive;
  private function get_self():Archive return lift(this);
}

class ArchiveLift{
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

}