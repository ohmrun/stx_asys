package stx.fs.path;

/**
  The portion of a normalized path between the `Stem` and the `Entry`
**/
typedef TrackDef = Cluster<String>;

/**
  The portion of a normalized path between the `Stem` and the `Entry`
**/
@:forward abstract Track(TrackDef) from TrackDef to TrackDef{
  public function new(?self:Cluster<String>) this = __.option(self).defv(Cluster.lift([]));
  @:noUsing static public function lift(self:TrackDef):Track return new Track(self);
  static public inline function unit(){
    return lift(Cluster.unit());
  }
  static public inline function pure(self:String){
    return lift(Cluster.pure(self));
  }
  @:from static public inline function fromArray(self:Array<String>){
    return lift(Cluster.lift(self));
  }
  public function canonical(sep):String{
    return this.join(sep);
  }
  public function snapshot():Track{
    return this.copy();
  }
  public function toRoute():Route{
    return this.map(Into);
  }
  public function concat(that:Track):Track{
    return lift(this.concat(that.prj()));
  }
  public function up():Upshot<Track,PathFailure>{
    return this.is_defined().if_else(
      () -> __.accept(lift(this.rdropn(1))),
      () -> __.reject(__.fault().of(E_Path_ReachedRoot))
    );
  }
  public function prj():TrackDef return this;
  private var self(get,never):Track;
  private function get_self():Track return lift(this);
}