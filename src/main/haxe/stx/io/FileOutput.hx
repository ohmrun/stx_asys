package stx.io;

typedef FileOutputDef = Tunnel<FileOutputRequest,FileOutputResponse,ASysFailure>;

@:using(stx.io.FileOutput.FileOutputLift)
abstract FileOutput(FileOutputDef) from FileOutputDef to FileOutputDef{
  static public var _(default,never) = FileOutputLift;
  public inline function new(self:FileOutputDef) this = self;
  @:noUsing static inline public function lift(self:FileOutputDef):FileOutput return new FileOutput(self);

  public function prj():FileOutputDef return this;
  private var self(get,never):FileOutput;
  private function get_self():FileOutput return lift(this);
}
class FileOutputLift{
  static public inline function lift(self:FileOutputDef):FileOutput{
    return FileOutput.lift(self);
  }
}