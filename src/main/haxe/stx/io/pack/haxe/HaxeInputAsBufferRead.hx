package stx.io.pack.haxe;

import stx.io.type.node.BufferRead;

class HaxeInputAsBufferRead{
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