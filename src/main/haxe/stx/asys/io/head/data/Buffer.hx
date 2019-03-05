package stx.asys.io.head.data; 

interface Buffer {

  var length(get,null):Int;
  private function get_length():Int;
  
  function copy(targetBuffer:Buffer,targetStart:Int,sourceStart:Int,sourceEnd:Int):Void;
  function slice(start:Int,end:Int):Buffer;
  function write(s:String,?offset:Int,?length:Int,?enc:String):Int;
  function toString(enc:String,?start:Int,?end:Int):String;
  function fill(value:Float,offset:Int,?end:Int):Void;
}