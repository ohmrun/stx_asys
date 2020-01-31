package stx.asys.fs.head.data;

enum FSFailure{
  IsNotADirectory;
  FileUnreadable(dyn:Dynamic);
  UnknownFSError;
  AlreadyExists;
  CannotReadDirectory;
}