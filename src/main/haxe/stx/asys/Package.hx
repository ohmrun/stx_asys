package stx.asys;

#if (test=="stx_asys")
  
#end

@:forward abstract Package(stx.asys.Module) from stx.asys.Module{
  static private var instance = new stx.asys.Module();
  public function new(){
    this = instance;
  }
  #if (test=="stx_asys")
    static public function tests(){
      return [
        
      ];
    }
  #end
}

typedef Device            = stx.asys.pack.Device;
typedef ASys              = stx.asys.pack.ASys;
typedef WorkingDirectory  = stx.asys.pack.WorkingDirectory;