package stx.fail;

import stx.fs.path.pack.Archive;

@:using(stx.fail.FsFailure.FsFailureLift)
enum FsFailure{
  IsNotADirectory;
  FileUnreadable(dyn:Dynamic);
  FileUnwriteable(dyn:Dynamic);
  UnknownFSError(?dyn:Dynamic);
  E_FileNotFound(archive:Archive);
  AlreadyExists;
  CannotReadDirectory;
  CannotSetWorkingDirectory(target:String,details:Dynamic);
  CannotCreate(path:String);
  //FilePathMalformed
  E_Fs_Path(fp:PathFailure);
  IsAlreadyRoot;
}
class FsFailureLift{
  static public function toASysFailure(self:FsFailure):ASysFailure{
    return E_ASys_Fs(self);
  }
}