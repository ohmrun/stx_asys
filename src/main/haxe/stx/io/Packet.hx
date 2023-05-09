package stx.io;

typedef PacketDef = {
  var data : Sprig;
  var type : ByteSize;
}
@:forward abstract Packet(PacketDef) from PacketDef{
  @:noUsing static public function make(data,type):Packet{
    return {
      data : data,
      type : type
    }
  }
  @:from static public function fromString(str:String):Packet{
  return {
      data : Textal(str),
      type : LINE
    };
  }
  public function toBytes(){
    var bytes = Bytes.alloc(
      this.type.get_width().def(
        () -> this.data.fold(
          s -> s.length,
          n -> n.get_width()
        )
      )
    );
    switch(this.data){
      case Byteal(NInt(int))    : bytes.setInt32(0,int);
      case Byteal(NInt64(int))  : bytes.setInt64(0,int);
      case Byteal(NFloat(f))    : bytes.setDouble(0,f);
      case Textal(t)            : bytes = Bytes.ofString(t);
    }
    return bytes;
  }
  // public function toString(){
  //   return switch(this.data){

  //   }
  // }
} 