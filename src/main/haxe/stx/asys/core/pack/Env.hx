package stx.asys.core.pack;

class Env implements stx.asys.core.type.Env extends Clazz{
  public function get(str:String):IO<String,SysFailure>{
    var fn = 
      Sys.getEnv.bind(str)
        .fnX()
        .then(chk -> chk.errata(err -> err.fault().of(EnvironmentVariablesInaccessible)));
        
    return IOs.fromUnary(fn);
  }
}