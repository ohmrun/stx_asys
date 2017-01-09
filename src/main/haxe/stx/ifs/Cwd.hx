package asys.ifs;

import tink.CoreApi;
import asys.Errors;

import tink.core.Future;
import tink.core.Outcome;

import stx.async.Promise;
import tink.core.Future;

interface Cwd{
  public function pop():Future<String>;
  public function put(str:String):Future<Null<Error>>;
}
