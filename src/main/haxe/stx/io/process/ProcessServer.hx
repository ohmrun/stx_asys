package stx.io.process;

import stx.io.process.server.term.Impl as ProcessServerCls;


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
@:using(stx.io.process.ProcessServer.ProcessServerLift)
@:transitive abstract ProcessServer(ProcessServerDef) from ProcessServerDef to ProcessServerDef{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ProcessServerDef):ProcessServer return new ProcessServer(self);

  public function prj():ProcessServerDef return this;
  private var self(get,never):ProcessServer;
  private function get_self():ProcessServer return lift(this);

  @:noUsing static public function makeI(command:Cluster<String>,?detached:Bool):ProcessServer{
    return ProcessServer.lift(ProcessServerCls.makeI(command,detached).reply());
  }
  @:to public function toProxy():Proxy<Closed,Noise,ProcessRequest,ProcessResponse,Noise,ProcessFailure>{
    return this.prj();
  }
}