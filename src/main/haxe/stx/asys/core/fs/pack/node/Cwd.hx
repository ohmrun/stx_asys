package stx.asys.core.fs.pack.node;

import stx.asys.core.fs.head.data.Cwd in CwdI;

class Cwd implements CwdI{
  public function pop():Future<String>{
    var trg = Future.trigger();
        trg.trigger(Node.process.cwd());
    return trg.asFuture();
  }
  public function put(str:String):Future<Null<tink.core.Error>>{
    var trg = Future.trigger();
    var o : Null<tink.core.Error> = (try{
      Node.process.chdir(str);
      null;
    }catch(e:Dynamic){
      Errors.internal_error(e);
    });
    trg.trigger(o);
    return trg.asFuture();
  }
}
