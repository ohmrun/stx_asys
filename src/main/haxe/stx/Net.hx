package stx;


import sys.net.Socket in StdSocket;

typedef Host = Dynamic;
typedef SocketOptionsBase = {
  port              : Int,
  host              : Host,
  
  ?max_connections  : Int,
  ?set_fast         : Bool,
  ?set_blocking     : Bool
}
typedef SocketServerOptions = SocketOptionsBase & {
  
}
typedef SocketClientOptions = SocketOptionsBase & {

}
enum SocketCommand{
  SC_Blocking(b:Bool);
  SC_Fast(b:Bool);
  SC_Timeout(t:Float);
  SC_Shutdown;
  SC_WaitForRead;
  SC_Read;
  SC_Write;
}
enum SocketRequest<T>{
  SR_Command(cmd:SocketCommand);
  SR_Payload(t:T);
}
enum SocketFailure{

}
typedef SocketProxyDef = 
  ProxySum<
    InputResponse,
    SocketRequest<InputRequest>, 
    Packet, 
    SocketRequest<OutputRequest>,
    Noise,
    SocketFailure
  >;
   
typedef SocketDef = ProxyCat<SocketServerOptions, InputResponse, SocketRequest<InputRequest>, Packet, SocketRequest<OutputRequest>, Noise, SocketFailure>;

abstract SocketServer(SocketDef) from SocketDef to SocketDef{
  public function new(){
    this = Unary.lift(method);
  }
  private static function method(options:SocketServerOptions){
    var socket = new StdSocket();
    return null;
  } 


  public function prj():SocketDef return this;
  
}
