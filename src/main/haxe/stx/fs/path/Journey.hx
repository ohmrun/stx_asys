package stx.fs.path;

/**
  Denormalized representation of a relative or absolute path, possibly including a file.
**/
typedef JourneyDef = {
  var drive : Stem;
  var tread : Either<Route,Track>;
  var entry : Option<Entry>;
}
@:using(stx.fs.path.Journey.JourneyLift)
@:forward abstract Journey(JourneyDef) from JourneyDef to JourneyDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:JourneyDef):Journey return new Journey(self);
  @:noUsing static public inline function unit():Journey{
    return make(Here,Right([]),None);
  }
  @:noUsing static public inline function make(drive:Stem,tread:Either<Route,Track>,entry:Option<Entry>):Journey{
    return lift({
      drive : drive,
      tread : tread,
      entry : entry
    });
  }
  public function canonical(sep:Separator):String{
    var head = switch(this.drive){
      case Here               : "./";
      case Root(Some(v))      : '${v}/';
      case Root(None)         : '/';
    }
    var body = switch(this.tread){
      case Left(route)  : route.canonical(sep);
      case Right(track) : track.canonical(sep);
    }
    var tail = this.entry.fold(
      (v) -> '/' + v.canonical(),
      () -> ''
    );
    return '${head}${body}${tail}';
  }
  public function prj():JourneyDef return this;
  private var self(get,never):Journey;
  private function get_self():Journey return lift(this);

  public function with_entry(entry:Entry){
    return make(this.drive,this.tread,Some(entry));
  }

  public function isDirectory():Bool{
    return this.entry.is_defined();
  }
}
class JourneyLift{
  static public function get_track(self:Journey):Upshot<Track,PathFailure>{
    return switch(self.tread){
      case Left(route)  : route.toTrack();
      case Right(track) : __.accept(track);
    }
  }
  static public function toDirectory(self:Journey):Upshot<Directory,PathFailure>{
    return get_track(self).flat_map(
      (track) -> switch(self.drive){
        case Here     : __.reject(__.fault().of(E_Path_ExpectedAbsolutePath));
        case Root(d)  : __.accept(Directory.make(d,track));
      }
    );
  }
  static public function toArchive(self:Journey):Upshot<Archive,PathFailure>{
    return
        self.drive.fold(
          () -> __.reject(__.fault().of(E_Path_ExpectedEntry)), 
          x -> __.accept(x)
        ).zip(get_track(self))
         .zip_with(
            self.entry.resolve(_ -> _.of(E_Path_ExpectedEntry)),
            (couple,entry) -> Archive.make(couple.fst(),couple.snd(),entry)
          );
  }
  static public function materialize(self:Journey):Upshot<Either<Directory,Archive>,PathFailure>{
    return self.isDirectory().if_else(
      () -> toDirectory(self).map(Left),
      () -> toArchive(self).map(Right)
    );
  }
}