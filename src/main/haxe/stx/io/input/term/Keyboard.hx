package stx.io.input.term;

typedef KeyboardDef = InputDef;

@:using(stx.io.Input.InputLift)
@:using(stx.io.input.term.Keyboard.KeyboardLift)
abstract Keyboard(KeyboardDef) from KeyboardDef to KeyboardDef{
  static public var _(default,never) = KeyboardLift;
  public inline function new(self:KeyboardDef) this = self;
  @:noUsing static inline public function lift(self:KeyboardDef):Keyboard return new Keyboard(self);

  public function prj():KeyboardDef return this;
  private var self(get,never):Keyboard;
  private function get_self():Keyboard return lift(this);

  static public function make(shell:ShellApi){
    function turn(stdin:InputDef):InputDef{
      return __.tran(
        function rec(x:InputRequest){
          return switch(x){
            case IReqValue(bs)                : switch(bs){
              case I8 : __.hold(
                shell.byte().map(
                  x -> __.emit(IResValue(Packet.make(Byteal(NInt(x)),I8)),__.tran(rec))
                ).recover(
                  e -> __.term(e)
                )
              );
              default : Tunnel._.mod(stdin.provide(x).prj(),turn);
            } 
            case x : Tunnel._.mod(stdin.provide(x),turn);
          };
        }
      );
    }
    return lift(turn(shell.stdin()));
  }
}
class KeyboardLift{
  static public inline function lift(self:KeyboardDef):Keyboard{
    return Keyboard.lift(self);
  }
}