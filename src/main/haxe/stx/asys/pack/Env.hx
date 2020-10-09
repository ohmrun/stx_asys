package stx.asys.pack;

interface EnvApi{ 
  public function get(string:String): Produce<String,ASysFailure>;
}
class Env implements EnvApi extends Clazz{
  public function get(str:String):Produce<String,ASysFailure>{
    return Produce.fromFunXRes(() -> try{
      __.accept(Sys.getEnv(str));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_EnvironmentVariablesInaccessible));
    });
  }
}