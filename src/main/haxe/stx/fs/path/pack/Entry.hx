package stx.fs.path.pack;

typedef EntryDef = {
              var name : String;
  @:optional  var ext  : String; 
}
/**
  An entry in a `Directory`, i.e the filename and extension
**/
@:using(stx.fs.path.pack.Entry.EntryLift)
@:forward abstract Entry(EntryDef) from EntryDef to EntryDef{
  public function new(self) this = self;
  static public function lift(self:EntryDef):Entry return new Entry(self);
  @:from static public function parse(str:String){
    var val = str.split(".");
    return switch(val.length){
      case 0  : throw "WOBBLARIA";
      case 1  : fromName(str);
      default : 
        var ext = val.pop();
        make(val.join("."),ext);
    }
  }
  @:noUsing static public function make(name,ext):Entry{
    return lift({name : name, ext : ext});
  }
  static public function fromName(name:String):Entry{
    return lift({ name : name });
  }  
  public function canonical(){
    return __.option(this.ext).map(
      ext -> '${this.name}.$ext'
    ).defv(this.name);
  }  
  public function toString(){
    return if(this.ext == null){
      '${this.name}';
    }else{
      '${this.name}.${this.ext}';
    }
  }
  public function prj():EntryDef return this;
  private var self(get,never):Entry;
  private function get_self():Entry return lift(this);

  static public function fromToken(self:Token):Option<Entry>{
    return switch(self){
      case FPTDrive(name)     : None;
      case FPTRel             : None;
      case FPTUp              : None;
      case FPTSep             : None;
      case FPTDown(str)       : 
        final arr = str.split(".");
        if(arr.length > 1){
          final ext = arr.pop();
          Some(Entry.make(arr.join("."),ext));
        }else{
          Some(Entry.make(str,null));
        }
      case FPTFile(str,ext)   : Some(Entry.make(str,ext));
    }
  }
}
class EntryLift{
  
}