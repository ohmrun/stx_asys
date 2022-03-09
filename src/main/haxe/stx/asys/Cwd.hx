package stx.asys;

using stx.Sys;

interface CwdApi{
  public function pop():Attempt<HasDevice,Directory,FsFailure>;
  public function put(str:Directory):Command<HasDevice,FsFailure>;
}

class Cwd implements CwdApi extends Clazz{
  public function pop():Attempt<HasDevice,Directory,FsFailure>{
    __.log().debug(__.sys().cwd().get());
    return 
      Path.parse(__.sys().cwd().get())
      .attempt(Raw._.toDirectory)
      .errate(E_Fs_Path);
  }
  public function put(dir:Directory):Command<HasDevice,FsFailure>{
    return Command.fromFun1Report(
      (env:HasDevice) -> {
        var val = Report.unit();
        try{
          __.sys().cwd().put(dir.canonical(env.device.sep));
        }catch(e:Dynamic){
          val = Report.pure(__.fault().of(E_Fs_CannotSetWorkingDirectory(dir.canonical(env.device.sep),e)));
        }
        return val;
      }
    );
  }
}