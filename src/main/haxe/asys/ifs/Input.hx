package asys.ifs;

interface Input{
  function readUInt16LE():Int;
  function readUInt16BE():Int;
  function readUInt32LE():Int;
  function readUInt32BE():Int;

  function readInt8():Int;
  function readInt16LE():Int;
  function readInt16BE():Int;
  function readInt32LE():Int;
  function readInt32BE():Int;

  function readFloatLE():Float;
  function readFloatBE():Float;
  function readDoubleLE():Float;
  function readDoubleBE():Float;
}