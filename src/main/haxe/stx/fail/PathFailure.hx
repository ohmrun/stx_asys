package stx.fail;

@:using(stx.fail.PathFailure.PathFailureLift)
enum PathFailureSum{
  //ParseFailed
  E_Path_PathParse(pf:PathParseFailure);
  E_Path_ReachedRoot;
  //E_Path_No
}
@:using(stx.fail.PathFailure.PathFailureLift)
@:transitive abstract PathFailure(PathFailureSum) from PathFailureSum to PathFailureSum{
  public function new(self) this = self;
  static public function lift(self:PathFailureSum):PathFailure return new PathFailure(self);

  public function prj():PathFailureSum return this;
  private var self(get,never):PathFailure;
  private function get_self():PathFailure return lift(this);

  @:from static public function fromPathParseFailure(self:PathParseFailure){
    return lift(E_Path_PathParse(self));
  }
}
class PathFailureLift{
  static public function toFsFailure(self:PathFailure):FsFailure{
    return E_Fs_Path(self);
  }
  static public function toASysFailure(self:PathFailure):ASysFailure{
    return E_ASys_Fs(E_Fs_Path(self));
  }
}