package stx.asys.io.pack;

import haxe.io.Output in StdOutput;

import stx.asys.io.head.Data.Output in IOutput;

class Output implements IOutput{
  static public inline function push(op:haxe.io.Output,value:Packet):Surprise<Noise,Error>{
    var valAsInt    = null;
    var valAsString = null;
    var valAsFloat  = null;

    switch(value.data){
      case PString(str):
        valAsString = str;
      case PFloat(fl):
        valAsFloat  = fl;
      case PInt(int):
        valAsInt    = int;
      default:
        __.fault().because("unsupported operation");
    }
    switch(value.type){
      case I8      :
        op.writeInt8(valAsInt);
      case I16BE   :
        op.bigEndian = true;
        op.writeInt16(valAsInt);
      case I16LE   :
        op.bigEndian = false;
        op.writeInt16(valAsInt);
      case UI16BE  :
        op.bigEndian = true;
        op.writeUInt16(valAsInt);
      case UI16LE  :
        op.bigEndian = false;
        op.writeUInt16(valAsInt);
      case I24BE   :
        op.bigEndian = true;
        op.writeInt24(valAsInt);
      case I24LE   :
        op.bigEndian = false;
        op.writeInt24(valAsInt);
      case UI24BE  :
        op.bigEndian = true;
        op.writeUInt24(valAsInt);
      case UI24LE  :
        op.bigEndian = false;
        op.writeUInt24(valAsInt);
      case I32BE   :
        op.bigEndian = true;
        op.writeInt32(valAsInt);
      case I32LE   :
        op.bigEndian = false;
        op.writeInt32(valAsInt);
      case FBE     :
        op.bigEndian = true;
        op.writeFloat(valAsFloat);
      case FLE     :
        op.bigEndian = false;
        op.writeFloat(valAsFloat);
      case DBE     :
        op.bigEndian = true;
        op.writeDouble(valAsFloat);
      case DLE     :
        op.bigEndian = false;
        op.writeDouble(valAsFloat);
      case LINE    :
        op.writeString(valAsString);
    }
    return Future.sync(Success(Noise));
  }
  /*
  static public function apply(opt:haxe.io.Output):Sink<Value>{
    return Constructors.wait(
      function recurse(val:Value):Sink<Value>{
          var out = Output.push(opt,val).map(
            (either) -> switch(either){
              case Success(Noise) : Constructors.wait(recurse);
              case Failure(e)     : Constructors.fail(e);
            }
          );
          return Constructors.hold(out);
        }
    );
  }*/
  private var _output : StdOutput;

  public function new(_output){
    this._output = _output;
  }
  public function writeUInt16LE(value:Int):Void{
    this._output.bigEndian = false;
    this._output.writeUInt16(value);
  }
  public function writeUInt16BE(value:Int):Void{
    this._output.bigEndian = true;
    this._output.writeUInt16(value);
  }
  // public function writeUInt32LE(value:Int):Void{
  //   this._output.bigEndian = false;
  //   this._output.writeUInt32(value);
  // }
  // public function writeUInt32BE(value:Int):Void{
  //   this._output.bigEndian = true;
  //   this._output.writeUInt32(value);
  // }
  public function writeInt8(value:Int):Void{
    this._output.writeInt8(value);
  }
  public function writeInt16LE(value:Int):Void{
    this._output.bigEndian = false;
    this._output.writeInt16(value);
  }
  public function writeInt16BE(value:Int):Void{
    this._output.bigEndian = true;
    this._output.writeInt16(value);
  }
  public function writeInt32LE(value:Int):Void{
    this._output.bigEndian = false;
    this._output.writeInt32(value);
  }
  public function writeInt32BE(value:Int):Void{
    this._output.bigEndian = true;
    this._output.writeInt32(value);
  }

  public function writeFloatLE(value:Float):Void{
    this._output.bigEndian = false;
    this._output.writeFloat(value);
  }
  public function writeFloatBE(value:Float):Void{
    this._output.bigEndian = true;
    this._output.writeFloat(value);
  }
  public function writeDoubleLE(value:Float):Void{
    this._output.bigEndian = false;
    this._output.writeDouble(value);
  }
  public function writeDoubleBE(value:Float):Void{
    this._output.bigEndian = true;
    this._output.writeDouble(value);
  }
  public function write(s:String):Void{
    this._output.writeString(s);
  }
}