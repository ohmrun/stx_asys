package stx.asys.type;

interface Env{ 
  public function get(string:String): Proceed<String,ASysFailure>;
}