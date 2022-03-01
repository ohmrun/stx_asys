package stx.fail;

import stx.fs.path.Archive;
import stx.fs.path.Directory;


@:using(stx.fail.FsFailure.FsFailureLift)
enum FsFailureSum{
  E_Fs_IsNotADirectory;
  E_Fs_FileUnreadable(dyn:Dynamic);
  E_Fs_FileUnwriteable(dyn:Dynamic);
  E_Fs_UnknownFSError(?dyn:Dynamic);
  E_Fs_FileNotFound(archive:Archive);
  E_Fs_DirectoryNotFound(dir:Directory);
  E_Fs_AlreadyExists;
  E_Fs_CannotReadDirectory;
  E_Fs_CannotSetWorkingDirectory(target:String,details:Dynamic);
  E_Fs_CannotCreate(path:String);
  //FilePathMalformed
  E_Fs_Path(fp:PathFailure);
  E_Fs_IsAlreadyRoot;
}
@:transitive abstract FsFailure(FsFailureSum) from FsFailureSum to FsFailureSum{
  static public var _(default,never) = FsFailureLift;
  public function new(self) this = self;
  static public function lift(self:FsFailureSum):FsFailure return new FsFailure(self);

  public function prj():FsFailureSum return this;
  private var self(get,never):FsFailure;
  private function get_self():FsFailure return lift(this);

  @:to public function toASysFailure():ASysFailure{
    return E_ASys_Fs(this);
  }
  @:from static public function fromPathFailure(self:PathFailure):FsFailure{
    return E_Fs_Path(self);
  }
  @:from static public function fromPathParseFailure(self:PathParseFailure):FsFailure{
    return E_Fs_Path(E_Path_PathParse(self));
  }
}
class FsFailureLift{
  static public function toASysFailure(self:FsFailure):ASysFailure{
    return E_ASys_Fs(self);
  }
}