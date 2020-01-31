package stx.asys.io.type.node; 

interface Buffer {

  var length(get,null):Int;
  private function get_length():Int;
  
  function copy(targetBuffer:Buffer,targetStart:Int,sourceStart:Int,sourceEnd:Int):EIO<IOFailure>;
  function slice(start:Int,end:Int):Buffer;
  function write(s:String,?offset:Int,?length:Int,?enc:String):IO<Int,IOFailure>;
  function toString(enc:String,?start:Int,?end:Int):IO<String,IOFailure>;
  function fill(value:Float,offset:Int,?end:Int):EIO<IOFailure>;
}