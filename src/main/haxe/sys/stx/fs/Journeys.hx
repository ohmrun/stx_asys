package sys.stx.fs;

class Journeys{
  static public function exists<T:HasDevice>(self:Journey):Attempt<T,Bool,FsFailure>{
    return (env:T) -> __.accept(FileSystem.exists(self.canonical(env.device.sep)));
  }
}