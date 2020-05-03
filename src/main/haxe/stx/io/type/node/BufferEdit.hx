package stx.io.type.node; 

interface BufferEdit{
    //function writeUInt8(value:Int):Void;
  function writeUInt16LE(value:Int):Execute<IOFailure>;
  function writeUInt16BE(value:Int):Execute<IOFailure>;
  //function writeUInt32LE(value:Int):Execute<IOFailure>;
  //function writeUInt32BE(value:Int):Execute<IOFailure>;

  function writeInt8(value:Int):Execute<IOFailure>;
  function writeInt16LE(value:Int):Execute<IOFailure>;
  function writeInt16BE(value:Int):Execute<IOFailure>;
  function writeInt32LE(value:Int):Execute<IOFailure>;
  function writeInt32BE(value:Int):Execute<IOFailure>;

  function writeFloatLE(value:Float):Execute<IOFailure>;
  function writeFloatBE(value:Float):Execute<IOFailure>;
  function writeDoubleLE(value:Float):Execute<IOFailure>;
  function writeDoubleBE(value:Float):Execute<IOFailure>;

  //function write(s:String,?offset:Int,?length:Int,?enc:String):Int;
  //function fill(value:Float,offset:Int,?end:Int):Void;
}