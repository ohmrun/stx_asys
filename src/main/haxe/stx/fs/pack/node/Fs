package asys.nodejs;

using stx.Maps;
using stx.Compose;
import asys.nodejs.File;
import asys.ifs.Fs in IFs;
import tink.core.Outcome;
import haxe.ds.StringMap;
import asys.fs.Stats;
import asys.Modes;
import stx.Path;
import stx.Upshot;
import tink.core.Future;
import stx.async.Promise;
import tink.core.Error;


class Fs implements IFs{
  public function rename(obj:{prev:Path, next:Path}):Future<Error>{
    return wrap1(js.node.Fs.rename.bind(obj.prev,obj.next));
  }
  public function truncate(obj:{path:Path, len:Int}):Future<Error>{
    return wrap1(js.node.Fs.truncate.bind(obj.path,obj.len));
  }
  public function chown(obj:{path:Path, uid:Int, gid:Int}):Future<Error>{
    return wrap1(js.node.Fs.chown.bind(obj.path,obj.uid,obj.gid));
  }
  public function chmod(obj:{path:Path, mode:Modes}):Future<Error>{
    var str : String = obj.mode;
    return wrap1(js.node.Fs.chmod.bind(obj.path,str));
  }
  /**
    The lchmod system call is similar to chmod but does not follow symbolic links.
  **/
  public function lchmod(obj:{path:Path, mode:Modes}):Future<Error>{
    var str : String = obj.mode;
    return wrap1(js.node.Fs.lchmod.bind(obj.path,str));
  }
  public function stat(path:String):Promise<Stats>{
    return wrap2(js.node.Fs.stat.bind(path));
  }
  /**
    Is identical to stat(), except that if path is a symbolic link, then the link itself is stat-ed, not the file that it refers to.
  **/
  public function lstat(path:String):Promise<Stats>{
    return wrap2(js.node.Fs.lstat.bind(path));
  }
  /**
    A hardlink isn't a pointer to a file, it's a directory entry (a file) pointing to the same inode. 
    Even if you change the name of the other file, a hardlink still points to the file. 
    If you replace the other file with a new version (by copying it), a hardlink will not point to the new file.
  **/
  public function link(obj:{src:Path, dst:Path}):Future<Error>{
    return wrap1(js.node.Fs.link.bind(obj.src,obj.dst));
  }

  public function symlink(obj:{src:Path, dst:Path, type:String}):Future<Error>{
    return wrap1(js.node.Fs.symlink.bind(obj.src,obj.dst,obj.type));
  }
  /**
    Returns the value of a symbolic link, if symbolic links are implemented.
  **/
  public function readlink(src:Path):Promise<Path>{
    return wrap2(js.node.Fs.readlink.bind(src));
  }

  public function path(obj:{path:String, cache:StringMap<Dynamic>}):Promise<Path>{
    return wrap2(js.node.Fs.realpath.bind(obj.path,obj.cache.toDynamic()));
  }
  public function unlink(path:String):Future<Error>{
    return wrap1(js.node.Fs.unlink.bind(path));
  }
  public function open(obj:{path:String, flags:Flag, ?mode:Modes}):Promise<asys.ifs.File>{
    var str : String = obj.mode;
    return wrap2(
      js.node.Fs.open.bind(obj.path,obj.flags,str)
    ).map(function(x:Int):asys.ifs.File return new File(x));
  }
  public function utimes(obj:{path:String, atime:Date, mtime:Date}):Future<Error>{
    return wrap1(js.node.Fs.utimes.bind(obj.path,obj.atime,obj.mtime));
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