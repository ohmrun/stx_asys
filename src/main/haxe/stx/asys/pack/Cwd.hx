package stx.asys.pack;


interface CwdApi{
  public function pop():Attempt<HasDevice,Directory,FSFailure>;
  public function put(str:Directory):Command<HasDevice,FSFailure>;
}

class Cwd implements CwdApi extends Clazz{
  public function pop():Attempt<HasDevice,Directory,FSFailure>{
    return 
      Path.parse(Sys.getCwd())
      .attempt(Raw._.toDirectory)
      .errata(
        e -> e.map(FilePathMalformed)
      );
  }
  public function put(dir:Directory):Command<HasDevice,FSFailure>{
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