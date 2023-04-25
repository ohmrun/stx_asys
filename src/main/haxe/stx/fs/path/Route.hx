package stx.fs.path;

/**
  The portion of a denormalized path between the `Stem` and the `Entry`
**/
typedef RouteDef = Cluster<Move>;

@:using(stx.fs.path.Route.RouteLift)
@:forward(lfold) abstract Route(RouteDef) from RouteDef to RouteDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:RouteDef):Route return new Route(self);
  @:noUsing static public function unit(){
    return fromArray([]);
  }
  @:from static public inline function fromArray(self:Array<Move>){
    return lift(Cluster.lift(self));
  }
  public function canonical(sep):String{
    return this.map(
      (move) -> switch(move){
        case Into(str)  : str;
        case From       : "..";
      }
    ).join(sep);
  }
  public function snoc(v):Route{
    return lift(this.snoc(v));
  }
  public function concat(that):Route{
    return this.concat(that);
  }
  public function prj():RouteDef return this;
  private var self(get,never):Route;
  private function get_self():Route return lift(this);
}
class RouteLift{
 static public function toTrack(self:Route):Upshot<Track,PathFailure>{
  return self.lfold(
    (next:Move,memo:Upshot<Cluster<String>,PathFailure>) -> {
      return memo.flat_map(
        ok -> switch(next){
          case Into(name) : __.accept(ok.snoc(name));
          case From       : (ok.is_defined()).if_else(
            () -> __.accept(ok.rdropn(1)),
            () -> __.reject(__.fault().of(E_Path_ReachedRoot))
          );
        }
      );
    },
    __.accept(Cluster.unit())
  );
 } 
}