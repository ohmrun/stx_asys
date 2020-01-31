package stx.asys.core.type;

interface Env{ 
  public function get(string:String): IO<String,SysFailure>;
}