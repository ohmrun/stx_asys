package stx.io.process;

enum ProcessStatusSum{
  Io_Process_Init;
  Io_Process_Open;
  Io_Process_Hung(calls:Int,?last:Float);
}
abstract ProcessStatus(ProcessStatusSum) from ProcessStatusSum to ProcessStatusSum{
  public function new(self) this = self;
  static public function lift(self:ProcessStatusSum):ProcessStatus return new ProcessStatus(self);

  public function prj():ProcessStatusSum return this;
  private var self(get,never):ProcessStatus;
  private function get_self():ProcessStatus return lift(this);

  public function hang():ProcessStatus{
    return lift(switch(this){
      case Io_Process_Hung(calls,last) : 
        Io_Process_Hung(calls == null ? 1 : calls + 1, last == null ? haxe.Timer.stamp() : last);
      default : 
        Io_Process_Hung(1,haxe.Timer.stamp());
    });
  }
}