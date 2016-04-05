package sync.asys;

import stx.types.Upshot;
import tink.core.Error;
import sys.fs.Flags;
import asys.types.Modes;
import sys.FileSystem;

import asys.ifs.File;

import stx.async.Futures;
import asys.Stat;
import stx.async.Promise;
import stx.Path;
import tink.core.Error;
import tink.core.Future;
import asys.ifs.Fs in IFs;

class Fs implements IFs{
  public function new(){

  }
  public function rename(obj:{prev:Path, next:Path}):Future<Error>{
    var error = null;
    try{
      FileSystem.rename(obj.prev,obj.next);
    }catch(e:Dynamic){
      error = e;
    }
    return Futures.pure(error);
  }
  public function stat(path:String):Promise<Stat>{
    var error   = null;
    var output  = null;
    try{
      output    =  FileSystem.stat(path);
    }catch(e:Dynamic){
      error     = e;
    }
    var stat = new Stat(output);
    return Promise.pure(if (error!= null){ Failure(new Error(400,error));}else{Success();});
  }
  public function unlink(path:String):Future<Null<Error>>{
    FileSystem.delete(path);
    return Futures.pure(null);
  }
  public function open(obj:{path:String, flags:Flags, ?mode:Modes}):Promise<File>{

  }

}
