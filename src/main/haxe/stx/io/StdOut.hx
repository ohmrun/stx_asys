package stx.io;

//TODO support INT64
@:using(stx.io.StdOut.StdOutLift)
abstract StdOut(StdOutput) from StdOutput{
  static public var _(default,never) = StdOutLift;
  @:noUsing static public function lift(self:StdOutput){
    return new StdOut(self);
  }
  public function new(self){
    this = self;
  }
  public function reply():Coroutine<OutputRequest,Report<IoFailure>,Noise,IoFailure>{
    function fn(value:OutputRequest){
      __.log().debug('pushing');
      var output      = Happened;
      var valAsInt    = Option.unit();
      var valAsString = Option.unit();
      var valAsFloat  = Option.unit();

      switch(value){
        case OReqClose:
          this.close();
          output = Report.unit();
        case OReqBytes(bytes) : 
          this.write(bytes);
          output = Report.unit();
        case OReqValue(packet):
          switch(packet.data){
            case Textal(str)        :          valAsString  = Some(str);
            case Byteal(NFloat(fl)) :          valAsFloat   = Some(fl);
            case Byteal(NInt(fl))   :          valAsInt     = Some(fl);
            //case PInt(int):             valAsInt    = Some(int);
            default:
              __.fault().of(E_Io_UnsupportedValue);
          }
          try{
            switch(packet.type){
              case I8      :
                for (val in valAsInt){ this.writeInt8(val); }
              case I16BE   :
                this.bigEndian = true;
                for (val in valAsInt){ this.writeInt16(val); }
              case I16LE   :
                this.bigEndian = false;
                for (val in valAsInt){ this.writeInt16(val); }
              case UI16BE  :
                this.bigEndian = true;
                for (val in valAsInt){ this.writeInt16(val); }
              case UI16LE  :
                this.bigEndian = false;
                for (val in valAsInt){ this.writeUInt16(val); }
              case I24BE   :
                this.bigEndian = true;
                for (val in valAsInt){ this.writeInt24(val); }
              case I24LE   :
                this.bigEndian = false;
                for (val in valAsInt){ this.writeInt24(val); }
              case UI24BE  :
                this.bigEndian = true;
                for (val in valAsInt){ this.writeUInt24(val); }
              case UI24LE  :
                this.bigEndian = false;
                for (val in valAsInt){ this.writeUInt24(val); }
              case I32BE   :
                this.bigEndian = true;
                for (val in valAsInt){ this.writeInt32(val); }
              case I32LE   :
                this.bigEndian = false;
                for (val in valAsInt){ this.writeInt32(val);  }
              case FBE     :
                this.bigEndian = true;
                for (val in valAsFloat){ this.writeFloat(val); }
              case FLE     :
                this.bigEndian = false;
                for (val in valAsFloat){ this.writeFloat(val);}
              case DBE     :
                this.bigEndian = true;
                for (val in valAsFloat){ this.writeDouble(val); }
              case DLE     :
                this.bigEndian = false;
                for (val in valAsFloat){ this.writeDouble(val); }
              case LINE    :
                for (val in valAsString){ this.writeString(val); }
            }
        }catch(e:Dynamic){
          output = Report.pure(__.fault().of(E_Io_Subsystem(e)));
        }
      }
      __.log()('pushed $output');
      return output;
    }
    return __.hold(
      stx.coroutine.core.Held.Guard(Future.irreversible(
        function(cb){
          cb(
            __.tran(
              function rec(value){
                return fn(value).fold(
                  err -> __.emit(err.report(),__.tran(rec)),
                  ()  -> __.tran(rec)
                );
              }
            )
          );
        }
      ))
    );
  }
}
class StdOutLift{

}