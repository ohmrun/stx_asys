package stx.fs.path.pack;

/**
  The portion of a normalized path between the `Stem` and the `Entry`
**/
typedef TrackDef = Array<String>;

@:forward abstract Track(TrackDef) from TrackDef to TrackDef{
  public function new(?self) this = __.option(self).defv([]);
  static public function lift(self:TrackDef):Track return new Track(self);
  
  public function canonical(sep):String{
    return this.join(sep);
  }
  public function snapshot():Track{
    return this.copy();
  }
  public function toRoute():Route{
    return this.map(Into);
  }
  public function prj():TrackDef return this;
  private var self(get,never):Track;
  private function get_self():Track return lift(this);
}