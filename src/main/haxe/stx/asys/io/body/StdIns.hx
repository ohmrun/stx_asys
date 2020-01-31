package stx.asys.io.body;

class StdIns{
  static public inline function pull(ip:StdInput,un:InputRequest):IO<InputResponse,IOFailure>{
    return (() -> {
      var prim : InputResponse              = null;
      var err  : TypedError<IOFailure>      = null;
      try{
        prim = apply(ip,un);
      }catch(e:Eof){
        err = __.fault().carrying('Eof',EndOfFile);
      }catch(e:haxe.io.Error){
        err  = __.fault().carrying('Process Error',Subsystem(e));
      }catch(e:Dynamic){
        err  = __.fault().carrying('Process Error',Subsystem(Custom(e)));
      }
      var out : Chunk<InputResponse,IOFailure> = __.option(End(err)).or(
        ()->__.option(Val(prim))
      ).defv(Tap);
      return out;
    }).broker(
      (F) -> F.then(IOs.fromChunkThunk)
    );
  }
  static function apply(ip:StdInput,un:InputRequest):InputResponse{
    return switch(un){
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
    }
  }
}