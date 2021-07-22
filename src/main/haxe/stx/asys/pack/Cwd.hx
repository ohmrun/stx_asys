package stx.asys.pack;


interface CwdApi{
  public function pop():Attempt<HasDevice,Directory,FsFailure>;
  public function put(str:Directory):Command<HasDevice,FsFailure>;
}

class Cwd implements CwdApi extends Clazz{
  public function pop():Attempt<HasDevice,Directory,FsFailure>{
    return 
      Path.parse(Sys.getCwd())
      .attempt(Raw._.toDirectory)
      .errate(E_Fs_Path);
  }
  public function put(dir:Directory):Command<HasDevice,FsFailure>{
    return Command.fromFun1Report(
      (env:HasDevice) -> {
        var val = Report.unit();
        try{
          Sys.setCwd(dir.canonical(env.device.sep));
        }catch(e:Dynamic){
          val = Report.pure(__.fault().of(CannotSetWorkingDirectory(dir.canonical(env.device.sep),e)));
        }
        return val;
      }
    );
  }
}