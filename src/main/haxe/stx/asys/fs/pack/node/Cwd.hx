package js.node.asys;

import asys.ifs.Cwd in ICwd;

import asys.Errors;

import tink.core.Future;
import js.Node;
import tink.core.Outcome;

import stx.async.Promise;
import tink.core.Future;

class Cwd implements ICwd{
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
