package stx.asys;

using stx.System;

interface EnvApi{ 
  public function get(string:String): Produce<Option<String>,ASysFailure>;
  public function toEnv():Env;
}
class Env implements EnvApi extends Clazz{
  public function get(str:String):Produce<Option<String>,ASysFailure>{
    return Produce.fromFunXUpshot(() -> try{
      __.accept(__.sys().env(str));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_ASys_EnvironmentVariablesInaccessible(str)));
    });
  }
  static public function Shim(map:haxe.ds.Map<String,String>):Env{
    return new stx.asys.env.term.Shim(map);
  }
  public function toEnv():Env{
    return this;
  }
}