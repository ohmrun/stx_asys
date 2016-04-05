package asys.nodejs;

import asys.ifs.Directory in IDirectory;

import tink.core.Outcome;
import haxe.ds.StringMap;
import asys.fs.Stats;
import asys.Modes;
import stx.Path;
import stx.Upshot;
import tink.core.Future;
import stx.async.Promise;
import tink.core.Error;

class Directory {
  public function mkdir(obj:{ path:Path, mode : Modes } ):Future<Error>{
    var str : String = obj.mode;
    return wrap1(Fs.mkdir.bind(obj.path,str));
  }
  public function rmdir(path:Path):Future<Error>{
    return wrap1(Fs.rmdir.bind(path));
  }
  public function readdir(path:Path):Promise<Array<String>>{
    return wrap2(Fs.readdir.bind(path));
  }
  private inline function error(native){
    return Error.withData('native error',native);
  }
  private inline function handler1<T>(ft:FutureTrigger<T>,err:Dynamic){
    ft.trigger(err);
  }
  private inline function handler2<T>(ft:FutureTrigger<Upshot<T>>,err:Dynamic,res:T){
    if(err!=null){
      ft.trigger(Failure(error(err)));
    }else{
      ft.trigger(Success(res));
    }
  }
  private inline function wrap1<T>(fn:(Dynamic->Void)->Void):Future<T>{
    var val = Future.trigger();
    fn(handler1.bind(val));
    return val.asFuture();
  } 
  private inline function wrap2<T>(fn:(Dynamic->T->Void)->Void):Promise<T>{
    var val = Future.trigger();
    fn(handler2.bind(val));
    return val.asFuture();
  }
} 