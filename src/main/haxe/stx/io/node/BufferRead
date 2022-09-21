package stx.io.type.node; 

interface BufferRead{
  function readUInt16LE():Produce<Int,IoFailure>;
  function readUInt16BE():Produce<Int,IoFailure>;

  //function readUInt32LE():Int;
  //function readUInt32BE():Int;

  function readInt8():Produce<Int,IoFailure>;
  function readInt16LE():Produce<Int,IoFailure>;
  function readInt16BE():Produce<Int,IoFailure>;
  function readInt32LE():Produce<Int,IoFailure>;
  function readInt32BE():Produce<Int,IoFailure>;

  function readFloatLE():Produce<Float,IoFailure>;
  function readFloatBE():Produce<Float,IoFailure>;
  function readDoubleLE():Produce<Float,IoFailure>;
  function readDoubleBE():Produce<Float,IoFailure>;
}