package stx.asys.fs;

typedef Volume    = stx.asys.fs.pack.Volume;

typedef FsString  = stx.asys.fs.pack.FsString;
typedef Dir       = stx.asys.fs.pack.Dir;
typedef File      = stx.asys.fs.pack.File;


@:forward abstract Package(stx.asys.fs.Module){
  static private var instance = new stx.asys.fs.Module();
  public function new(){
    this = instance;
  }
}