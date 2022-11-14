package stx.io;
 
@:using(stx.io.StdIn.StdInLift)
abstract StdIn(StdInput) from StdInput{
  static public var _(default,never) = StdInLift;
  @:noUsing static public function lift(self:StdInput){
    return new StdIn(self);
  }
  public function new(self){
    this = self;
  }
  public function reply():Tunnel<InputRequest,InputResponse,IoFailure>{
    var state = Io_Input_Unknown;
    function apply(ip:StdInput,un:InputRequest):InputResponse{
      return switch(un){ 
        case IReqState      : IResState(state);
        case IReqValue(x)   : 
          var prim = 
            switch(x){
                case I8      : Byteal(NInt(ip.readInt8()));
                case I16BE   : ip.bigEndian = true;   Byteal(NInt(ip.readInt16()));
                case I16LE   : ip.bigEndian = false;  Byteal(NInt(ip.readInt16()));
                case UI16BE  : ip.bigEndian = true;   Byteal(NInt(ip.readUInt16()));
                case UI16LE  : ip.bigEndian = false;  Byteal(NInt(ip.readUInt16()));
                case I24BE   : ip.bigEndian = true;   Byteal(NInt(ip.readInt24()));
                case I24LE   : ip.bigEndian = false;  Byteal(NInt(ip.readInt24()));
                case UI24BE  : ip.bigEndian = true;   Byteal(NInt(ip.readUInt24()));
                case UI24LE  : ip.bigEndian = false;  Byteal(NInt(ip.readUInt24()));
                case I32BE   : ip.bigEndian = true;   Byteal(NInt(ip.readInt32()));
                case I32LE   : ip.bigEndian = false;  Byteal(NInt(ip.readInt32()));
                case FBE     : ip.bigEndian = true;   Byteal(NFloat(ip.readFloat()));
                case FLE     : ip.bigEndian = false;  Byteal(NFloat(ip.readFloat()));
                case DBE     : ip.bigEndian = true;   Byteal(NFloat(ip.readDouble()));
                case DLE     : ip.bigEndian = false;  Byteal(NFloat(ip.readDouble()));
                case LINE    :                        Textal(ip.readLine());
              }
          IResValue({ data : prim, type : x});
        case IReqBytes(pos,len) :
          var bytes = Bytes.alloc(len);
          ip.readBytes(bytes,pos,len);
          IResBytes(bytes);
        case IReqClose:    
          switch(state){
            case Io_Input_Closed(_) : 
            default : 
              state = Io_Input_Closed(None,true);
              ip.close(); 
          }
          IResStarved;
        case IReqTotal(buffer_size) :
          var bytes = ip.readAll(buffer_size);
          IResBytes(bytes);
      }
    }
    final pull = (un:InputRequest) -> {
      __.log().trace('pulling $un');
      var prim : InputResponse              = null;
      var err  : Refuse<IoFailure>        = null;
      try{
        prim = apply(this,un);
        __.log().trace('pull ok');
      }catch(e:Eof){
        __.log().error('pull fail $e');
        state = Io_Input_Closed(None,false);
        prim  = IResStarved;
      }catch(e:haxe.io.Error){
        __.log().error('pull fail $e');
        state = Io_Input_Closed(Some(Error.make(Some(Std.string(e)),None,None)),false);
        err  = __.fault().of(E_Io_Subsystem(e));
      }catch(e:Dynamic){
        state = Io_Input_Closed(Some(Error.make(Some(Std.string(e)),None,None)),false);
        __.log().error('pull fail $e');
        err  = __.fault().of(E_Io_Subsystem(Custom(e)));
       }
      __.log().trace('pulled: $prim');
      var out : Res<InputResponse,IoFailure> = __.option(err).map(e -> __.reject(e)).def(
        ()-> __.accept(prim)
      );
      return out;
    };
    //TODO implement Control
    return Tunnel.lift(__.tran(
      function rec(ipt:InputRequest):Coroutine<InputRequest,InputResponse,Noise,IoFailure>{
        return switch([state,ipt]){
          case [_,IReqState]                        : __.emit(IResState(state),__.tran(rec));
          case [Io_Input_Closed(_),IReqValue(_)]    : __.quit(__.fault().of(E_Io_EndOfFile));
          case [Io_Input_Closed(_),IReqBytes(_,_)]  : __.quit(__.fault().of(E_Io_EndOfFile));
          case [Io_Input_Closed(_),IReqClose]       : __.stop();
          case [Io_Input_Closed(_),IReqTotal(_)]    : __.quit(__.fault().of(E_Io_EndOfFile));
          case [_,IReqClose]      :
            switch(state){
              case Io_Input_Closed(_) : 
              default                 : 
                this.close(); 
                state = Io_Input_Closed(None,true);
            }
            __.stop();
          case [_,x]              :
              pull(x)
               .fold(
                  ok -> __.emit(ok,__.tran(rec)),
                  no -> __.quit(no) 
                );
        }
      }
    ));
  }
  public function prj():StdInput{
    return this;
  }
}
class StdInLift{

}