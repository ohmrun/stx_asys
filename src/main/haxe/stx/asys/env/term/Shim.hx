package stx.asys.env.term;

class Shim extends Env{
  final map : haxe.ds.Map<String,String>;
  public function new(map){
    super();
    this.map = map;
  }
  override public function get(string:String): Produce<Option<String>,ASysFailure>{
    return Produce.pure(
      __.option(map.get(string))
    );
  }
}