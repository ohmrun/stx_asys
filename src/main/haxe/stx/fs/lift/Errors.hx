package stx.fs.lift;

class Errors {
  static public inline function is_not_directory(f:Fault):TypedError<FSFailure>{
    return f.of(IsNotADirectory);
  }
}