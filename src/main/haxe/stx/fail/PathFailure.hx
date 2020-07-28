package stx.fail;

@:using(stx.fail.PathFailure.PathFailureLift)
enum PathFailure{
  //ParseFailed
  E_Path_PathParse(pf:PathParseFailure);
  E_Path_ReachedRoot;
}
class PathFailureLift{
  static public function toFsFailure(self:PathFailure):FsFailure{
    return E_Fs_Path(self);
  }
  static public function toASysFailure(self:PathFailure):ASysFailure{
    return E_ASys_Fs(E_Fs_Path(self));
  }
}