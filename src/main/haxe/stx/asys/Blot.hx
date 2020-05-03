package stx.asys;

class Blot{
  #if (test=="stx_asys")
    static public function sep(__:Wildcard){
      throw "Don't use global separator here";
    }
  #end
}