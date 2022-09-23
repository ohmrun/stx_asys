package stx.io.process;

typedef ProcessClientCat<R> = Unary<X,ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>>;