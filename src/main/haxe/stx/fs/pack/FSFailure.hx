package stx.fs.pack;

enum FSFailure{
  IsNotADirectory;
  FileUnreadable(dyn:Dynamic);
  UnknownFSError(?dyn:Dynamic);
  AlreadyExists;
  CannotReadDirectory;
  CannotSetWorkingDirectory(target:String,details:Dynamic);
  CannotCreate(path:String);
  FilePathMalformed(fp:PathFailure);
  IsAlreadyRoot;
}