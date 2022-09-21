package stx.io;

typedef ProcessFailure                  = stx.fail.ProcessFailure;

typedef Process                         = stx.io.process.Process;
typedef ProcessCls                      = stx.io.process.Process.ProcessCls;
typedef ProcessDef                      = stx.io.process.Process.ProcessDef;

typedef ProcessClientDef<R>             = stx.io.process.ProcessClient.ProcessClientDef<R>;
typedef ProcessClient<R>                = stx.io.process.ProcessClient<R>;

typedef ProcessRequest                  = stx.io.process.ProcessRequest;
typedef ProcessResponse                 = stx.io.process.ProcessResponse;

typedef ProcessStatusSum                = stx.io.process.ProcessStatus.ProcessStatusSum;
typedef ProcessStatus                   = stx.io.process.ProcessStatus;

typedef ProcessProxy<G,H,R,E>           = stx.io.process.ProcessProxy<G,H,R,E>;
typedef ProcessProxyDef<G,H,R,E>        = stx.io.process.ProcessProxy.ProcessProxyDef<G,H,R,E>;
