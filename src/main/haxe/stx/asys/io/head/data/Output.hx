package stx.asys.io.head.data;

interface Output{
  //function writeUInt8(value:Int):Void;
  function writeUInt16LE(value:Int):Void;
  function writeUInt16BE(value:Int):Void;
  //function writeUInt32LE(value:Int):Void;
  //function writeUInt32BE(value:Int):Void;

  function writeInt8(value:Int):Void;
  function writeInt16LE(value:Int):Void;
  function writeInt16BE(value:Int):Void;
  function writeInt32LE(value:Int):Void;
  function writeInt32BE(value:Int):Void;

  function writeFloatLE(value:Float):Void;
  function writeFloatBE(value:Float):Void;
  function writeDoubleLE(value:Float):Void;
  function writeDoubleBE(value:Float):Void;

  //function write(s:String,?offset:Int,?length:Int,?enc:String):Int;
  //function fill(value:Float,offset:Int,?end:Int):Void;
}