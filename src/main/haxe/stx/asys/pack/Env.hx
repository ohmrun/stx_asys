package stx.asys.pack;

interface EnvApi{ 
  public function get(string:String): Proceed<String,ASysFailure>;
}
class Env implements EnvApi extends Clazz{
  public function get(str:String):Proceed<String,ASysFailure>{
    return Proceed.fromFunXRes(() -> try{
      __.accept(Sys.getEnv(str));
    }catch(e:Dynamic){
      __.reject(__.fault().of(E_EnvironmentVariablesInaccessible));
    });
  }
}