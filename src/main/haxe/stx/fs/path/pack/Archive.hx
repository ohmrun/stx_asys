package stx.fs.path.pack;

/**
  Represents the description of an absolute path from the root of the filesystem
  to a file handle.
**/
typedef ArchiveDef = {
  var drive : Drive;
  var track : Track;
  var entry : Entry;
}

@:forward abstract Archive(ArchiveDef) from ArchiveDef to ArchiveDef{
  static public var _(default,never) = ArchiveLift;
  public function new(self) this = self;
  static public function lift(self:ArchiveDef):Archive return new Archive(self);
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
  public function update(data:String):Command<HasDevice,FSFailure> return _.update(self,data);
  public function upsert(data:String)                              return _.upsert(self,data);
  public function directory():Directory{
      return Directory.make(this.drive,this.track);
  }
  public function prj():ArchiveDef return this;
  private var self(get,never):Archive;
  private function get_self():Archive return lift(this);
}

class ArchiveLift extends Clazz{
  static public function update(self:Archive,data:String):Command<HasDevice,FSFailure>{
    return ((env:HasDevice) -> {
      var out = None;
      try{
        StdFile.saveContent(self.canonical(env.device.sep),data);
      }catch(e:Dynamic){
        out = Some(__.fault().of(UnknownFSError(e)));
      }
      return out;
    }).broker(
      F -> Command.fromFun1Option
    );
  }
  static public function upsert(self:Archive,data:String){
    var lhs = self.directory().inject();
    var rhs = self.update(data);
    var two = lhs.and(rhs);
    return two;
  }
}