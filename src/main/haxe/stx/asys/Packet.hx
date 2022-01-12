package stx.asys;

typedef PacketDef = {
  var data : Sprig;
  var type : ByteSize;
}
@:forward abstract Packet(PacketDef) from PacketDef{
  @:from static public function fromString(str:String):Packet{
  return {
      data : Textal(str),
      type : LINE
    };
  }
  // public function toString(){
  //   return switch(this.data){

  //   }
  // }
} 