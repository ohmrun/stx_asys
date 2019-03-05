package stx.asys.io.pack;

import haxe.io.Input in StdInput;

import stx.asys.io.head.Data.Input in IInput;

class Input implements IInput{
  static public inline function pull(ip:haxe.io.Input,un:Peck):Iota{
    return switch (un) {
      case I8      :
        PInt(ip.readInt8());
      case I16BE   :
        ip.bigEndian = true;
        PInt(ip.readInt16());
      case I16LE   :
        ip.bigEndian = false;
        PInt(ip.readInt16());
      case UI16BE  :
        ip.bigEndian = true;
        PInt(ip.readUInt16());
      case UI16LE  :
        ip.bigEndian = false;
        PInt(ip.readUInt16());

      case I24BE   :
        ip.bigEndian = true;
        PInt(ip.readInt24());
      case I24LE   :
        ip.bigEndian = false;
        PInt(ip.readInt24());
      case UI24BE  :
        ip.bigEndian = true;
        PInt(ip.readUInt24());
      case UI24LE  :
        ip.bigEndian = false;
        PInt(ip.readUInt24());

      case I32BE   :
        ip.bigEndian = true;
        PInt(ip.readInt32());
      case I32LE   :
        ip.bigEndian = false;
        PInt(ip.readInt32());
      case FBE     :
        ip.bigEndian = true;
        PFloat(ip.readFloat());
      case FLE     :
        ip.bigEndian = false;
        PFloat(ip.readFloat());
      case DBE     :
        ip.bigEndian = true;
        PFloat(ip.readDouble());
      case DLE     :
        ip.bigEndian = false;
        PFloat(ip.readDouble());
      case LINE    :
        PString(ip.readLine());
    };
  }
  static public function apply(ip:haxe.io.Input):Simplex<Peck,Iota,Noise>{
    function producer(un:Peck):Simplex<Peck,Iota,Noise>{
      var o = null;
          o = try{
            Constructors.emit(
              pull(ip,un),
              Constructors.wait(producer)
            );
          }catch(e:Error){
            Constructors.fail(e);
          }catch(d:Dynamic){
            Constructors.fail(Error.withData(500,'Error in Input',d));
          }
      return o;
    }
    return Wait(producer);
  }

  var _input : StdInput;
  public function new(_input:StdInput){
    this._input = _input;
  }
  public function readUInt16LE():Int{
    _input.bigEndian = false;
    return _input.readUInt16();
  }
  public function readUInt16BE():Int{
    _input.bigEndian = true;
    return _input.readUInt16();
  }
  // public function readUInt32LE():Int{
  //   _input.bigEndian = false;
  //   return _input.readUInt32();
  // }
  // public function readUInt32BE():Int{
  //   _input.bigEndian = true;
  //   return _input.readUInt32();
  // }
  public function readInt8():Int{
    return _input.readByte();
  }
  public function readInt16LE():Int{
    _input.bigEndian = false;
    return _input.readInt16();
  }
  public function readInt16BE():Int{
    _input.bigEndian = true;
    return _input.readInt16();
  }
  public function readInt32LE():Int{
    _input.bigEndian = false;
    return _input.readInt32();
  }
  public function readInt32BE():Int{
    _input.bigEndian = true;
    return _input.readInt32();
  }
  public function readFloatLE():Float{
    _input.bigEndian = false;
    return _input.readFloat();
  }
  public function readFloatBE():Float{
    _input.bigEndian = true;
    return _input.readFloat();
  }
  public function readDoubleLE():Float{
    _input.bigEndian = false;
    return _input.readDouble();
  }
  public function readDoubleBE():Float{
    _input.bigEndian = true;
    return _input.readDouble();
  }
}