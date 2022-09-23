package stx.io;

typedef ProcessFailure                  = stx.fail.ProcessFailure;

typedef ProcessServer                   = stx.io.process.ProcessServer;

typedef ProcessServerDef                = stx.io.process.ProcessServer.ProcessServerDef;

typedef ProcessClientDef<R>             = stx.io.process.ProcessClient.ProcessClientDef<R>;
typedef ProcessClient<R>                = stx.io.process.ProcessClient<R>;

typedef ProcessRequest                  = stx.io.process.ProcessRequest;
typedef ProcessResponse                 = stx.io.process.ProcessResponse;

typedef ProcessStatusSum                = stx.io.process.ProcessStatus.ProcessStatusSum;
typedef ProcessStatus                   = stx.io.process.ProcessStatus;

typedef ProcessServerCatDef             = stx.io.process.ProcessServerCat.ProcessServerCatDef;
typedef ProcessServerCat                = stx.io.process.ProcessServerCat;

typedef ProcessProxy<G,H,R,E>           = stx.io.process.ProcessProxy<G,H,R,E>;
typedef ProcessProxyDef<G,H,R,E>        = stx.io.process.ProcessProxy.ProcessProxyDef<G,H,R,E>;
