package stx.fs.path;

using eu.ohmrun.Pml;

using stx.fs.path.Directory;

//TODO change `attach` to something else
/**
  Represents an absolute path between the root of a file system
  to a known directory.
**/
typedef DirectoryDef = {
  var drive : Drive;
  var track : Track;
}
@:using(stx.fs.path.Directory.DirectoryLift)
@:forward abstract Directory(DirectoryDef) from DirectoryDef to DirectoryDef{
  public function new(self) this = self;
  static public var _(default,never) = DirectoryLift;
  
  @:noUsing static public function lift(self:DirectoryDef):Directory    return new Directory(self);
  @:noUsing static public function make(drive:Drive,track:Track):Directory{
    return Directory.lift({
      drive : drive,
      track : track
    });
  }
  @:noUsing static public function fromArray(arr:Array<String>):Directory{
    return arr.head().flat_map(
      (str) -> (str.charAt(str.length - 1) == ":").if_else(
        () -> Some(str),
        () -> None
      )
    ).map(
      (str) -> make(Some(str),arr.tail())
    ).def(
      () -> make(None,arr)
    );
  }
  static public function parse(string:String){
    return Path.parse(string).attempt(Raw._.toDirectory);
  }

  public function prj():DirectoryDef return this;
  private var self(get,never):Directory;
  private function get_self():Directory return lift(this);

  public function canonical(sep:Separator){
    var head    = this.drive.fold(
      (v) -> v + '$sep',
      () -> '$sep'
    );
    var body    = this.track.canonical(sep);
    __.log().debug(_ -> _.pure(head));
    __.log().debug(_ -> _.pure(body));
    return head + body;
  }
  public function toString():String{
    return canonical(cast "::");
  }
  public function components():Cluster<String>
    return this.drive.fold(
      (v) -> Track.pure(v).concat(this.track),
      ()  -> this.track
    );

  
  public function into(track:TrackDef):Directory{
    return make(this.drive,this.track.concat(track));
  }
  public function entry(entry:Entry):Archive{
    return Archive.make(this.drive,this.track,entry);
  }
  static public var pos = __.here();
}
class DirectoryLift{
  static public function eq(self:Directory):Eq<Directory>{
    return new stx.assert.eq.term.fs.path.Directory();
  }
  static public function down(self:Directory,next:String):Directory{
    return Directory.make(self.drive,self.track.snoc(next));
  }
  static public function parent(self:Directory):Produce<Directory,FsFailure>{
    var fn = () -> {
      var track = self.track.snapshot().rdropn(1);
      return Directory.make(
        self.drive,
        track
      );
    };
    return Produce.fromFunXR(fn).errata(
      (e) -> e.fault().of(E_Fs_UnknownFSError(e.data))
    );
  }
  
  //TODO: I should probably `HasDevice` this.
  static public function search_ancestors(self:Directory,arw:Modulate<HasDevice & EnquireDef<Directory>,Bool,FsFailure>):Modulate<HasDevice,Option<Directory>,FsFailure>{
    return Modulate.fromFun1Produce((state:HasDevice) -> return arw.flat_map(
    (
        (b:Bool) -> b.if_else(
          () -> Modulate.pure(Some(self)),
          () -> self.parent().toModulate().modulate(
            Modulate.fromFun1Produce(
              (that:Directory) -> eq(self).comply(self,that).is_ok().if_else(
                () -> Produce.pure(None),
                () -> search_ancestors(that,arw).produce(__.accept(state))
              )
            )
          )
        )
      )
    ).produce(__.accept({ device : state.device, enquire : self })));
  }

  @:noUsing static public inline function into(self:Directory,track:TrackDef):Directory{
    return self.into(track);
  }
  static public function archive(self:Directory,that:Attachment):Upshot<Archive,FsFailure>{
    return that.track.lfold(
      (next:Move,memo:Upshot<Track,FsFailure>) -> switch([next,memo]){
          case [Into(name),Accept(dir)] : __.accept(dir.concat([name]));
          case [From,Accept(dir)]       : dir.up().errate(e -> (e:FsFailure));
          case [_,Reject(_)]            : memo;
      },
      __.accept(self.track)
    ).map(
      (next:Track) -> Archive.lift({
        drive : self.drive,
        track : next,
        entry : that.entry
      })
    );
  }
  
  static public function is_root(self:Directory):Bool{
    return !self.track.is_defined();
  }
  // static public function up(self:Directory){
  //   return is_root(self).if_else(
  //     () -> __.reject(__.fault().of(E_Path_ReachedRoot).errate(e -> (e:FsFailure))),
  //     () -> self.track.up().map(track -> Dir.make(dir.drive,track))
  //   );
  // }
  static public function toAddress(self:DirectoryDef):Address{
    return Address.make(self.drive,self.track,None);
  }
}