package sys.stx.io.process;

#if (sys || nodejs)
import sys.stx.io.process.server.term.Impl as ProcessServerCls;

/**
 * Server that sends `ProcessRequests` to `stdout` and produces `ProcessResponses`.
 * Requires a `ProcessClient` to operate.
 */
typedef ProcessServerDef = Server<ProcessRequest,ProcessResponse,Noise,ProcessFailure>;

class ProcessServerLift{
  static inline public function lift(self:ProcessServerDef):ProcessServer{
    return ProcessServer.lift(self);
  }
  static public function provide(self:ProcessServer,req:ProcessRequest):ProcessServer{
    return lift(Server._.provide(self.prj(),req));
  }
  static public function drain(self:ProcessServerDef,?buffer):ProcessServer{
    var that  = provide(self,PReqInput(IReqTotal(buffer),false));
    return that;
  }
}

@:using(stx.proxy.core.Proxy.ProxyLift)
@:using(stx.proxy.core.Server.ServerLift)
@:using(sys.stx.io.process.ProcessServer.ProcessServerLift)
@:transitive abstract ProcessServer(ProcessServerDef) from ProcessServerDef to ProcessServerDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ProcessServerDef):ProcessServer return new ProcessServer(self);

  public function prj():ProcessServerDef return this;
  private var self(get,never):ProcessServer;
  private function get_self():ProcessServer return lift(this);

  @:noUsing static public function makeI(command:Cluster<String>,?detached:Bool):ProcessServer{
    return ProcessServer.lift(ProcessServerCls.makeI(command,detached).reply());
  }
  @:noUsing static public function make(command:Cluster<String>,?detached:Bool):ProcessServer{
    return ProcessServer.lift(ProcessServerCls.makeI(command,detached).reply());
  }
  // @:noUsing static public function Make(command:Cluster<String>,?detached:Bool):Server<ProcessRequest,ProcessResponse,Noise,ProcessFailure>{
  //   return make(command,detached);
  // }
  @:to public function toProxy():Proxy<Closed,Noise,ProcessRequest,ProcessResponse,Noise,ProcessFailure>{
    return this.prj();
  }
}
#end