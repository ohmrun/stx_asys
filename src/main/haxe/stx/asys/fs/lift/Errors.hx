package stx.asys.fs.lift;

class Errors {
  static public inline function is_not_directory(f:Fault,str):TypedError<FSFailure>{
    return f.carrying('"$str" is not a directory',IsNotADirectory);
  }
}