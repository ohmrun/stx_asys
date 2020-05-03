package stx.fs.path.channel.term;

typedef RawDef<T:HasDevice> = Channel<String,Array<Token>,PathFailure>;

@:forward abstract Raw(RawDef) from RawDef to RawDef{
  private  function new(self) this = self;

  static public function fromString<T:HasDevice>(string:String):Raw{
    return Attempt.fromAttemptFunction((env:T) -> 
        env.device.distro.is_windows().if_else(
          () -> new Windows().asBase(),
          () -> new Posix().asBase()
        ).parse(string.reader())
         .fold(
          (a,_)               -> __.success(a),
          (e,xs,is_error)     -> __.failure(__.fault().of(ParseFailed(MalformedSource(Failure(e,xs,is_error)))))    
        )
      );
  }

}