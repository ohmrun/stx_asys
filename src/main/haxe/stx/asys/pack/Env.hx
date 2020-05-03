package stx.asys.pack;

interface EnvApi{ 
  public function get(string:String): Proceed<String,ASysFailure>;
}
class Env implements EnvApi extends Clazz{
  public function get(str:String):Proceed<String,ASysFailure>{
    return () -> try{
      __.success(Sys.getEnv(str));
    }catch(e:Dynamic){
      __.failure(__.fault().of(EnvironmentVariablesInaccessible));
    }
  }
}