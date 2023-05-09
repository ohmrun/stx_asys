package stx.asys.env.term;

class Shim implements EnvApi{
  final map : haxe.ds.Map<String,String>;
  public function new(map){
    this.map = map;
  }
  public function get(string:String): Produce<Option<String>,ASysFailure>{
    return Produce.pure(
      __.option(map.get(string))
    );
  }
  public function toEnvApi():EnvApi{
    return this;
  }
}