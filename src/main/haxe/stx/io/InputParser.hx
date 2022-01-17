package stx.io;

/**
  `InputParser` consumes `InputResponse`'s and can request `InputRequest`'s
**/
typedef InputParserDef<R> = CoroutineSum<InputResponse,InputRequest,ParseResult<InputResponse,R>,stx.parse.core.ParseError>;

@:using(stx.coroutine.core.Coroutine.CoroutineLift)
abstract InputParser<R>(InputParserDef<R>) from InputParserDef<R> to InputParserDef<R>{
  public function new(self) this = self;
  static public function lift<R>(self:InputParserDef<R>):InputParser<R> return new InputParser(self);

  public function prj():InputParserDef<R> return this;
  private var self(get,never):InputParser<R>;
  private function get_self():InputParser<R> return lift(this);

  @:from static public function fromCoroutine<R>(self:Coroutine<InputResponse,InputRequest,ParseResult<InputResponse,R>,stx.parse.core.ParseError>){
    return lift(self);
  }
  @:noUsing static public function unit():InputParser<Bytes>{
    var input : Option<Bytes> = None;
    final len = ()      -> input.map(x -> x.length).defv(0);
    final add = (rhs:Bytes)   -> input.fold(
      (lhs) -> {
        final next : Bytes = Bytes.alloc(lhs.length + rhs.length);
              next.blit(lhs.length,rhs,0,rhs.length);
              input = __.option(next);
              null;
      },
      () -> {
        input = __.option(rhs);
        null;
      }
    );
    return lift(
      __.emit(
        IReqTotal(),
        __.tran(
          function rec(x:InputResponse){ 
            __.log().debug(_ -> _.pure(x));
            return switch(x){
              case IResValue(p)         : 
                __.exit(__.fault().explain(_ -> _.e_input_unexpected_response()));
              case IResBytes(b)         : 
                add(b);
                input.fold(
                  (bytes) -> {
                    var res = bytes;
                    return __.prod(ParseResult.make([IResBytes(res)].reader(),res));
                  },
                  ()      -> __.exit(__.fault().explain(_ -> _.e_input_unexpected_end()))
                );
              case IResSpent            :
                __.exit(__.fault().explain(_ -> _.e_input_unexpected_end()));
              case IResState(state)     :
                __.exit(__.fault().explain(_ -> _.e_input_unexpected_response())); 
            }
          }
        )
      )
    );
  }
}
