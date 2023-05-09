package stx.asys;

interface EnvApi{ 
  public function get(string:String): Produce<Option<String>,ASysFailure>;
}