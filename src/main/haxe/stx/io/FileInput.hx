package stx.io;

typedef FileInputDef = Tunnel<FileInputResponse,FileInputResponse,stx.fail.ASysFailure>;

@:using(stx.io.FileInput.FileInputLift)
abstract FileInput(FileInputDef) from FileInputDef to FileInputDef{
  static public var _(default,never) = FileInputLift;
  public inline function new(self:FileInputDef) this = self;
  @:noUsing static inline public function lift(self:FileInputDef):FileInput return new FileInput(self);

  public function prj():FileInputDef return this;
  private var self(get,never):FileInput;
  private function get_self():FileInput return lift(this);
}
class FileInputLift{
  static public inline function lift(self:FileInputDef):FileInput{
    return FileInput.lift(self);
  }
}