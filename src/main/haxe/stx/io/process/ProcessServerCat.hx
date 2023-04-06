package stx.io.process;

typedef ProcessServerCatDef = Unary<{command:Cluster<String>,?detached:Bool},ProcessServer>;

/**
  Is a RespondCat. P -> Proxy<A,B,X,Y,R,E>
**/
abstract ProcessServerCat(ProcessServerCatDef) from ProcessServerCatDef to ProcessServerCatDef{
  public function new() {
    this = (args) -> {
      return ProcessServer.makeI(args.command,args.detached);
    }
  }
  public function prj():ProcessServerCatDef return this;
  @:to public function toRespondCat():RespondCat<{command:Cluster<String>,?detached:Bool},Closed,Noise,ProcessRequest,ProcessResponse,Noise,ProcessFailure>{
    return this;
  }
}