package stx.io.type.node; 

interface BufferRead{
  function readUInt16LE():Proceed<Int,IOFailure>;
  function readUInt16BE():Proceed<Int,IOFailure>;

  //function readUInt32LE():Int;
  //function readUInt32BE():Int;

  function readInt8():Proceed<Int,IOFailure>;
  function readInt16LE():Proceed<Int,IOFailure>;
  function readInt16BE():Proceed<Int,IOFailure>;
  function readInt32LE():Proceed<Int,IOFailure>;
  function readInt32BE():Proceed<Int,IOFailure>;

  function readFloatLE():Proceed<Float,IOFailure>;
  function readFloatBE():Proceed<Float,IOFailure>;
  function readDoubleLE():Proceed<Float,IOFailure>;
  function readDoubleBE():Proceed<Float,IOFailure>;
}