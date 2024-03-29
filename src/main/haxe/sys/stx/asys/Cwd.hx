package sys.stx.asys;

class Cwd implements CwdApi extends Clazz{
  public function pop():Attempt<HasDevice,Directory,FsFailure>{
    __.log().debug(Sys.cwd().get());
    return 
      Path.parse(Sys.cwd().get())
      .attempt(Raw._.toDirectory)
      .errate(E_Fs_Path);
  }
  public function put(dir:Directory):Command<HasDevice,FsFailure>{
    return Command.fromFun1Report(
      (env:HasDevice) -> {
        var val = Report.unit();
        try{
          Sys.cwd().put(dir.canonical(env.device.sep));
        }catch(e:Dynamic){
          val = Report.pure(__.fault().of(E_Fs_CannotSetWorkingDirectory(dir.canonical(env.device.sep),e)));
        }
        return val;
      }
    );
  }
}