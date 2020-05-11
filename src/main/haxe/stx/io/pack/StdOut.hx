package stx.io.pack;


@:using(stx.io.pack.StdOut.StdOutLift)
abstract StdOut(StdOutput) from StdOutput{
  static public var _(default,never) = StdOutLift;
  public function new(self){
    this = self;
  }
  public function apply(type:OutputRequest):Execute<IOFailure>{
    return StdOutLift.push(this,type);
  }
}
class StdOutLift{
  static public inline function push(op:StdOutput,value:OutputRequest):Execute<IOFailure>{
    function fn(){
      var output      = None;
      var valAsInt    = None;
      var valAsString = None;
      var valAsFloat  = None;

      switch(value){
        case OReqClose:
          op.close();
          output = Report.unit();
        case OReqValue(packet):
          switch(packet.data){
            case PString(str):          valAsString = Some(str);
            case PFloat(fl):            valAsFloat  = Some(fl);
            case PInt(int):             valAsInt    = Some(int);
            default:
              __.fault().of(UnsupportedValue);
          }
          try{
            switch(packet.type){
              case I8      :
                for (val in valAsInt){ op.writeInt8(val); }
              case I16BE   :
                op.bigEndian = true;
                for (val in valAsInt){ op.writeInt16(val); }
              case I16LE   :
                op.bigEndian = false;
                for (val in valAsInt){ op.writeInt16(val); }
              case UI16BE  :
                op.bigEndian = true;
                for (val in valAsInt){ op.writeInt16(val); }
              case UI16LE  :
                op.bigEndian = false;
                for (val in valAsInt){ op.writeUInt16(val); }
              case I24BE   :
                op.bigEndian = true;
                for (val in valAsInt){ op.writeInt24(val); }
              case I24LE   :
                op.bigEndian = false;
                for (val in valAsInt){ op.writeInt24(val); }
              case UI24BE  :
                op.bigEndian = true;
                for (val in valAsInt){ op.writeUInt24(val); }
              case UI24LE  :
                op.bigEndian = false;
                for (val in valAsInt){ op.writeUInt24(val); }
              case I32BE   :
                op.bigEndian = true;
                for (val in valAsInt){ op.writeInt32(val); }
              case I32LE   :
                op.bigEndian = false;
                for (val in valAsInt){ op.writeInt32(val);  }
              case FBE     :
                op.bigEndian = true;
                for (val in valAsFloat){ op.writeFloat(val); }
              case FLE     :
                op.bigEndian = false;
                for (val in valAsFloat){ op.writeFloat(val);}
              case DBE     :
                op.bigEndian = true;
                for (val in valAsFloat){ op.writeDouble(val); }
              case DLE     :
                op.bigEndian = false;
                for (val in valAsFloat){ op.writeDouble(val); }
              case LINE    :
                for (val in valAsString){ op.writeString(val); }
            }
        }catch(e:Dynamic){
          output = Report.pure(__.fault().of(Subsystem(e)));
        }
      }
      return output;
    }
    return Execute.fromFunXR(fn);
  }
}