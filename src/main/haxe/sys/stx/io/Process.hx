package sys.stx.io;

class Process{
  
}

typedef ProcessServer                   = sys.stx.io.process.ProcessServer;
typedef ProcessServerDef                = sys.stx.io.process.ProcessServer.ProcessServerDef;

typedef ProcessClientDef<R>             = sys.stx.io.process.ProcessClient.ProcessClientDef<R>;
typedef ProcessClient<R>                = sys.stx.io.process.ProcessClient<R>;

typedef ProcessClientCatDef<R>          = sys.stx.io.process.ProcessClientCat.ProcessClientCatDef<R>;
typedef ProcessClientCat<R>             = sys.stx.io.process.ProcessClientCat<R>;


typedef ProcessServerCatDef             = sys.stx.io.process.ProcessServerCat.ProcessServerCatDef;
typedef ProcessServerCat                = sys.stx.io.process.ProcessServerCat;

typedef ProcessProxy<G,H,R,E>           = sys.stx.io.process.ProcessProxy<G,H,R,E>;
typedef ProcessProxyDef<G,H,R,E>        = sys.stx.io.process.ProcessProxy.ProcessProxyDef<G,H,R,E>;