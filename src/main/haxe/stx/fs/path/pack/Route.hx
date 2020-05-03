package stx.fs.path.pack;

/**
  The portion of a denormalized path between the `Stem` and the `Entry`
**/
typedef RouteDef = Array<Move>;

@:forward(lfold) abstract Route(RouteDef) from RouteDef to RouteDef{
  public function new(self) this = self;
  static public function lift(self:RouteDef):Route return new Route(self);
  

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