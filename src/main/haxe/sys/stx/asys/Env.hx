package sys.stx.asys;

class Env implements EnvApi extends Clazz{
  public function get(str:String):Produce<Option<String>,ASysFailure>{
    return Produce.fromFunXUpshot(() -> try{
      __.accept(Sys.env(str));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_ASys_EnvironmentVariablesInaccessible(str)));
    });
  }
  static public function Shim(map:haxe.ds.Map<String,String>):EnvApi{
    return new stx.asys.env.term.Shim(map).toEnvApi();
  }
  public function toEnvApi():Env{
    return this;
  }
}