package stx.io.process;

typedef ProcessProxyDef<G,H,R,E> = ProxySum<ProcessRequest,ProcessResponse,G,H,R,E>;

abstract ProcessProxy<G,H,R,E>(ProcessProxyDef<G,H,R,E>) from ProcessProxyDef<G,H,R,E> to ProcessProxyDef<G,H,R,E>{
  public function new(self) this = self;
  @:noUsing static public function lift<G,H,R,E>(self:ProcessProxyDef<G,H,R,E>):ProcessProxy<G,H,R,E> return new ProcessProxy(self);

  public function prj():ProcessProxyDef<G,H,R,E> return this;
  private var self(get,never):ProcessProxy<G,H,R,E>;
  private function get_self():ProcessProxy<G,H,R,E> return lift(this);
}