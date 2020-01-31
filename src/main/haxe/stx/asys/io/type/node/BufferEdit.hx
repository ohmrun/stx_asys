package stx.asys.io.type.node; 

interface BufferEdit{
    //function writeUInt8(value:Int):Void;
  function writeUInt16LE(value:Int):EIO<IOFailure>;
  function writeUInt16BE(value:Int):EIO<IOFailure>;
  //function writeUInt32LE(value:Int):EIO<IOFailure>;
  //function writeUInt32BE(value:Int):EIO<IOFailure>;

  function writeInt8(value:Int):EIO<IOFailure>;
  function writeInt16LE(value:Int):EIO<IOFailure>;
  function writeInt16BE(value:Int):EIO<IOFailure>;
  function writeInt32LE(value:Int):EIO<IOFailure>;
  function writeInt32BE(value:Int):EIO<IOFailure>;

  function writeFloatLE(value:Float):EIO<IOFailure>;
  function writeFloatBE(value:Float):EIO<IOFailure>;
  function writeDoubleLE(value:Float):EIO<IOFailure>;
  function writeDoubleBE(value:Float):EIO<IOFailure>;

  //function write(s:String,?offset:Int,?length:Int,?enc:String):Int;
  //function fill(value:Float,offset:Int,?end:Int):Void;
}