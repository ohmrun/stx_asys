package stx.asys.io.type.node; 

interface BufferRead{
  function readUInt16LE():IO<Int,IOFailure>;
  function readUInt16BE():IO<Int,IOFailure>;

  //function readUInt32LE():Int;
  //function readUInt32BE():Int;

  function readInt8():IO<Int,IOFailure>;
  function readInt16LE():IO<Int,IOFailure>;
  function readInt16BE():IO<Int,IOFailure>;
  function readInt32LE():IO<Int,IOFailure>;
  function readInt32BE():IO<Int,IOFailure>;

  function readFloatLE():IO<Float,IOFailure>;
  function readFloatBE():IO<Float,IOFailure>;
  function readDoubleLE():IO<Float,IOFailure>;
  function readDoubleBE():IO<Float,IOFailure>;
}