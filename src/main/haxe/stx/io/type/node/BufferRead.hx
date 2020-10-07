package stx.io.type.node; 

interface BufferRead{
  function readUInt16LE():Proceed<Int,IoFailure>;
  function readUInt16BE():Proceed<Int,IoFailure>;

  //function readUInt32LE():Int;
  //function readUInt32BE():Int;

  function readInt8():Proceed<Int,IoFailure>;
  function readInt16LE():Proceed<Int,IoFailure>;
  function readInt16BE():Proceed<Int,IoFailure>;
  function readInt32LE():Proceed<Int,IoFailure>;
  function readInt32BE():Proceed<Int,IoFailure>;

  function readFloatLE():Proceed<Float,IoFailure>;
  function readFloatBE():Proceed<Float,IoFailure>;
  function readDoubleLE():Proceed<Float,IoFailure>;
  function readDoubleBE():Proceed<Float,IoFailure>;
}