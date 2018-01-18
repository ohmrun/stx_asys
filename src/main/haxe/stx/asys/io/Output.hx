package asys.io;

import haxe.io.Output in StrOutput;

import asys.ifs.Output in IOutput;

class Output implements IOutput{
  private var _output : StdOutput;

  public function new(_output){
    this._output = _output;
  }
  public function writeUInt16LE(value:Int):Void{
    this._output.bigEndian = false;
    return this._output.writeUInt16(value);
  }
  public function writeUInt16BE(value:Int):Void{
    this._output.bigEndian = true;
    return this._output.writeUInt16(value);
  }
  public function writeUInt32LE(value:Int):Void{
    this._output.bigEndian = false;
    return this._output.writeUInt32(value);
  }
  public function writeUInt32BE(value:Int):Void{
    this._output.bigEndian = true;
    return this._output.writeUInt32(value);
  }
  public function writeInt8(value:Int):Void{
    return this._output.writeInt8(value);
  }
  public function writeInt16LE(value:Int):Void{
    this._output.bigEndian = false;
    return this._output.writeInt16(value);
  }
  public function writeInt16BE(value:Int):Void{
    this._output.bigEndian = true;
    return this._output.writeInt16(value);
  }
  public function writeInt32LE(value:Int):Void{
    this._output.bigEndian = false;
    return this._output.writeInt32(value);
  }
  public function writeInt32BE(value:Int):Void{
    this._output.bigEndian = true;
    return this._output.writeInt32(value);
  }

  public function writeFloatLE(value:Float):Void{
    this._output.bigEndian = false;
    return this._output.writeFloat();
  }
  public function writeFloatBE(value:Float):Void{
    this._output.bigEndian = true;
    return this._output.writeFloat();
  }
  public function writeDoubleLE(value:Float):Void{
    this._output.bigEndian = false;
    return this._output.writeDouble();
  }
  public function writeDoubleBE(value:Float):Void{
    this._output.bigEndian = true;
    return this._output.writeDouble();
  }
  public function write(s:String):Int{
    return this._output.writeString(s);
  }
}