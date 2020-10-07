package stx.io.type.node; 

interface Buffer {

  var length(get,null):Int;
  private function get_length():Int;
  
  function copy(targetBuffer:Buffer,targetStart:Int,sourceStart:Int,sourceEnd:Int):Execute<IoFailure>;
  function slice(start:Int,end:Int):Buffer;
  function write(s:String,?offset:Int,?length:Int,?enc:String):Proceed<Int,IoFailure>;
  function toString(enc:String,?start:Int,?end:Int):Proceed<String,IoFailure>;
  function fill(value:Float,offset:Int,?end:Int):Execute<IoFailure>;
}