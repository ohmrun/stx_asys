package sys.stx.io.process;

#if (sys || nodejs)
/**
  Await `ProcessRequest`'s to be sent to a `ProcessServer`, handle `ProcessResponse`'s
**/
typedef ProcessClientDef<R> = stx.proxy.core.Client.ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>;

@:transitive
@:using(stx.proxy.core.Proxy.ProxyLift)
@:using(sys.stx.io.process.ProcessClient.ProcessClientLift)
abstract ProcessClient<R>(ProcessClientDef<R>) from ProcessClientDef<R> to ProcessClientDef<R>{
  static public var _(default,never) = ProcessClientLift;
  public inline function new(self:ProcessClientDef<R>) this = self;
  @:noUsing static inline public function lift<R>(self:ProcessClientDef<R>):ProcessClient<R> return new ProcessClient(self);

  public function prj():ProcessClientDef<R> return this;
  private var self(get,never):ProcessClient<R>;
  private function get_self():ProcessClient<R> return lift(this);

  static public function Reply(?error):ProcessClient<Bytes>{
    return lift(new sys.stx.io.process.client.term.Reply(error));
  }
  static public function NotErrored<R>(next:ProcessClientDef<R>):ProcessClient<R>{
    return lift(sys.stx.io.process.client.term.NotErrored.make(next));
  }
  static public function Timer<R>(next:ProcessClientDef<R>,ms:Int):ProcessClient<R>{
    return lift(sys.stx.io.process.client.term.Timer.make(ms,next));
  }
  static public function Request(req):ProcessClient<ProcessResponse>{
    return lift(new sys.stx.io.process.client.term.Request(req));
  }
}
class ProcessClientLift{
  static public inline function lift<R>(self:ProcessClientDef<R>):ProcessClient<R>{
    return ProcessClient.lift(self);
  }
}
#end