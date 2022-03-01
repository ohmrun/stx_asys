package stx.fs.path;

/**
 * Represents the root of a volume, whether named or not.
**/
enum StemSum{
  Here;
  Root(drive:Drive);
}
abstract Stem(StemSum) from StemSum to StemSum{
  public function new(self) this = self;
  static public function lift(self:StemSum):Stem return new Stem(self);

  public function prj():StemSum return this;
  private var self(get,never):Stem;
  private function get_self():Stem return lift(this);

  public function fold<Z>(here:()->Z,root:Drive->Z){
    return switch(this){
      case Here         : here();
      case Root(drive)  : root(drive);
    }
  }
}