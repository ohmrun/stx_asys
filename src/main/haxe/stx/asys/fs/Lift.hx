package stx.asys.fs;

typedef Errors = stx.asys.fs.lift.Errors;

class Lift{
  static public function fs(_:Wildcard):Module{
    return new Module();
  }
}