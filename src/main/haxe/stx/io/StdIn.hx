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
    var closed = false;
    function apply(ip:StdInput,un:InputRequest):InputResponse{
      return switch(un){
        case IReqState    : IResState(({ closed : closed }:InputState));
        case IReqValue(x) :
          var prim = 
            switch(x){
                case I8      : PInt(ip.readInt8());
                case I16BE   : ip.bigEndian = true;   PInt(ip.readInt16());
                case I16LE   : ip.bigEndian = false;  PInt(ip.readInt16());
                case UI16BE  : ip.bigEndian = true;   PInt(ip.readUInt16());
                case UI16LE  : ip.bigEndian = false;  PInt(ip.readUInt16());
                case I24BE   : ip.bigEndian = true;   PInt(ip.readInt24());
                case I24LE   : ip.bigEndian = false;  PInt(ip.readInt24());
                case UI24BE  : ip.bigEndian = true;   PInt(ip.readUInt24());
                case UI24LE  : ip.bigEndian = false;  PInt(ip.readUInt24());
                case I32BE   : ip.bigEndian = true;   PInt(ip.readInt32());
                case I32LE   : ip.bigEndian = false;  PInt(ip.readInt32());
                case FBE     : ip.bigEndian = true;   PFloat(ip.readFloat());
                case FLE     : ip.bigEndian = false;  PFloat(ip.readFloat());
                case DBE     : ip.bigEndian = true;   PFloat(ip.readDouble());
                case DLE     : ip.bigEndian = false;  PFloat(ip.readDouble());
                case LINE    :                        PString(ip.readLine());
              }
          IResValue(({
            data : prim,
            type : x
          }:Packet));
        case IReqBytes(pos,len) :
          var bytes = Bytes.alloc(len);
          ip.readBytes(bytes,pos,len);
          IResBytes(bytes);
        case IReqClose:    
          if(!closed){
            ip.close(); 
          }
          IResSpent;
        case IReqTotal(buffer_size) :
          var bytes = ip.readAll(buffer_size);
          IResBytes(bytes);

          
      }
    }
    final pull = (un:InputRequest) -> {
      __.log().debug("pulling");
      var prim : InputResponse       = null;
      var err  : Err<IoFailure>      = null;
      try{
        prim = apply(this,un);
        __.log().debug('pull ok');
      }catch(e:Eof){
        __.log().debug('pull fail $e');
        prim = IResSpent;
      }catch(e:haxe.io.Error){
        __.log().debug('pull fail $e');
        err  = __.fault().of(Subsystem(e));
      }catch(e:Dynamic){
        __.log().debug('pull fail $e');
        err  = __.fault().of(Subsystem(Custom(e)));
      }
      __.log().debug('pulled: $prim');
      var out : Res<InputResponse,IoFailure> = __.option(err).map(__.reject).def(
        ()-> __.accept(prim)
      );
      return out;
    };
    //TODO implement Control4
    return Tunnel.lift(__.tran(
      function rec(ipt:InputRequest):Coroutine<InputRequest,InputResponse,Noise,IoFailure>{
        return switch([closed,ipt]){
          case [_,IReqState]          : __.emit(IResState(({ closed : closed }:InputState)),__.tran(rec));
          case [true,IReqValue(_)]    : __.quit(__.fault().of(EndOfFile));
          case [true,IReqBytes(_,_)]  : __.quit(__.fault().of(EndOfFile));
          case [true,IReqClose]       : __.stop();
          case [false,IReqClose]      :
            if(!closed){
              this.close(); 
            }
            closed = true; 
            __.stop();
          case [false,x]              :
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