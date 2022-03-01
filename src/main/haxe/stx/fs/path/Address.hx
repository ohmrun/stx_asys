package stx.fs.path;

/**
  Denormalized representation of a relative or absolute path, possibly including a file.
**/
typedef AddressDef = {
  var drive : Stem;
  var track : Either<Route,Track>;
  var entry : Option<Entry>;
}
@:using(stx.fs.path.Address.AddressLift)
@:forward abstract Address(AddressDef) from AddressDef to AddressDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:AddressDef):Address return new Address(self);
  @:noUsing static public inline function unit():Address{
    return make(Here,Right([]),None);
  }
  @:noUsing static public inline function make(drive:Stem,track:Either<Route,Track>,entry:Option<Entry>):Address{
    return lift({
      drive : drive,
      track : track,
      entry : entry
    });
  }
  public function canonical(sep:Separator):String{
    var head = switch(this.drive){
      case Here               : "./";
      case Root(Some(v))      : '${v}/';
      case Root(None)         : '/';
    }
    var body = switch(this.track){
      case Left(route)  : route.canonical(sep);
      case Right(track) : track.canonical(sep);
    }
    var tail = this.entry.fold(
      (v) -> '/' + v.canonical(),
      () -> ''
    );
    return '${head}${body}${tail}';
  }
  public function exists<T:HasDevice>():Attempt<T,Bool,FsFailure>{
    return (env:T) -> __.accept(FileSystem.exists(canonical(env.device.sep)));
  }
  public function prj():AddressDef return this;
  private var self(get,never):Address;
  private function get_self():Address return lift(this);

  public function with_entry(entry:Entry){
    return make(this.drive,this.track,Some(entry));
  }

  public function isDirectory():Bool{
    return this.entry.is_defined();
  }
}
class AddressLift{
  static public function toDirectory(){
    return switch()
  }()
  //static public function materialize()
}