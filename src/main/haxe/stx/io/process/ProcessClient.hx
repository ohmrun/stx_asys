package stx.io.process;

typedef ProcessClientDef<R> = stx.proxy.core.Client.ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>;

@:using(stx.io.process.ProcessClient.ProcessClientLift)
abstract ProcessClient<R>(ProcessClientDef<R>) from ProcessClientDef<R> to ProcessClientDef<R>{
  static public var _(default,never) = ProcessClientLift;
  public inline function new(self:ProcessClientDef<R>) this = self;
  @:noUsing static inline public function lift<R>(self:ProcessClientDef<R>):ProcessClient<R> return new ProcessClient(self);

  public function prj():ProcessClientDef<R> return this;
  private var self(get,never):ProcessClient<R>;
  private function get_self():ProcessClient<R> return lift(this);

static public function Reply():ProcessClient<Bytes>{
    return lift(new stx.io.process.client.term.Reply());
  }
}
class ProcessClientLift{
  static public inline function lift<R>(self:ProcessClientDef<R>):ProcessClient<R>{
    return ProcessClient.lift(self);
  }
}