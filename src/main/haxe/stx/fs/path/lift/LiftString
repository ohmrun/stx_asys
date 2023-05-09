package stx.fs.path.lift;

class LiftString{
  static public function toJourney(string:String):Journey{
    return Path.parse(string).attempt(Raw._.toJourney).provide(__.asys().local()).fudge();
  }
  static public function toDirectory(string:String):Directory{
    return Path.parse(string).attempt(Raw._.toDirectory).provide(__.asys().local()).fudge();
  }
  static public function toArchive(string:String):Archive{
    return Path.parse(string).attempt(Raw._.toArchive).provide(__.asys().local()).fudge();
  }
}