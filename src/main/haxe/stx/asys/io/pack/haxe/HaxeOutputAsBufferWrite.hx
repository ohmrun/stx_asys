package stx.asys.io.pack.haxe;

import stx.asys.io.type.node.BufferEdit;

class HaxeOutputAsBufferWrite implements BufferEdit{
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