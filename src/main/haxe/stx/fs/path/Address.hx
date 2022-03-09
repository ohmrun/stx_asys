package stx.fs.path;

/**
  A normalized step by step from the root node to somewhere that may be a directory or a file.
**/
typedef AddressDef = {
  final drive : Drive;
  final track : Track;
  final entry : Option<Entry>;
}
@:using(stx.fs.path.Address.AddressLift)
@:forward abstract Address(AddressDef) from AddressDef to AddressDef{
  public function new(self) this = self;
  static public function lift(self:AddressDef):Address return new Address(self);
  static public function make(drive,track,entry){
    return lift({
      drive : drive,
      track : track,
      entry : entry
    });
  }
  public function canonical(sep:Separator){
    var head    = this.drive.fold(
      (v) -> v + '$sep',
      () -> '$sep'
    );
    var body    = this.track.canonical(sep);
    var tail    = this.entry.map(e -> e.canonical()).map(s -> '#sep$s').defv(sep);
    __.log().debug(_ -> _.pure(head));
    __.log().debug(_ -> _.pure(body));
    __.log().debug(_ -> _.pure(tail));
    return head + body + tail;
}
  public function prj():AddressDef return this;
  private var self(get,never):Address;
  private function get_self():Address return lift(this);
}
class AddressLift{
  static public function lift(self:AddressDef):Address{
    return Address.lift(self);
  }
  static public function is_directory(self:AddressDef){
    return Attempt.fromFun1Res(
      (state:HasDevice) -> {
        return try{
          final canonical = lift(self).canonical(state.device.sep);
          final is_dir    = sys.FileSystem.isDirectory(canonical);
          __.accept(is_dir); 
        }catch(e:Dynamic){
          //trace(e);
          __.reject(__.fault().of(E_Fs_DirectoryNotFound(null)));
        }
      }
    );
  }
  static public function toDirectory(self:AddressDef){
    return Directory.make(
      self.drive,
      self.track
    );
  }
}
