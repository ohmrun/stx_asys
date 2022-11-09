package stx.io.process;

typedef ProcessClientCatDef<R> = Unary<ProcessResponse,ClientDef<ProcessRequest,ProcessResponse,R,ProcessFailure>>;

@:using(stx.fn.Unary.UnaryLift)
abstract ProcessClientCat<R>(ProcessClientCatDef<R>) from ProcessClientCatDef<R> to ProcessClientCatDef<R>{
  public function new(self) this = self;
  @:noUsing static public function lift<R>(self:ProcessClientCatDef<R>):ProcessClientCat<R> return new ProcessClientCat(self);

  public function prj():ProcessClientCatDef<R> return this;
  private var self(get,never):ProcessClientCat<R>;
  private function get_self():ProcessClientCat<R> return lift(this);

  static public function Reply(){
    return lift(stx.io.process.client.term.Reply.cat);
  }
}