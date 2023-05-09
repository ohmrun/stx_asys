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
  public function directory():Directory{
      return Directory.make(this.drive,this.track);
  }
  public function prj():ArchiveDef return this;
  private var self(get,never):Archive;
  private function get_self():Archive return lift(this);
}

class ArchiveLift{
  
}