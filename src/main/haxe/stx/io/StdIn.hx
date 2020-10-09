package stx.io;

@:using(stx.io.StdIn.StdInLift)
abstract StdIn(StdInput) from StdInput{
  static public var _(default,never) = StdInLift;
  public function new(self){
    this = self;
  }
  public function apply(type:InputRequest):Produce<InputResponse,IoFailure>{
    return StdInLift.pull(this,type);
  }
  public function prj():StdInput{
    return this;
  }
  public function pull(un:InputRequest):Produce<InputResponse,IoFailure>{
    return _.pull(this,un);
  }
}
class StdInLift{
  static public inline function pull(ip:StdInput,un:InputRequest):Produce<InputResponse,IoFailure>{
    return () -> {
      var prim : InputResponse       = null;
      var err  : Err<IoFailure>      = null;
      try{
        prim = apply(ip,un);
      }catch(e:Eof){
        err = __.fault().of(EndOfFile);
      }catch(e:haxe.io.Error){
        err  = __.fault().of(Subsystem(e));
      }catch(e:Dynamic){
        err  = __.fault().of(Subsystem(Custom(e)));
      }
      var out : Res<InputResponse,IoFailure> = __.option(err).map(__.reject).def(
        ()-> __.accept(prim)
      );
      return out;
    };
  }
  static function apply(ip:StdInput,un:InputRequest):InputResponse{
    return switch(un){
      //case IReqStart    : 
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
        IResSpent;

    }
  }
}