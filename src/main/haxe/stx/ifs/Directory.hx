package asys.ifs;

import tink.core.Outcome;
import haxe.ds.StringMap;
import asys.fs.Stats;
import asys.Modes;
import stx.Path;
import stx.Upshot;
import tink.core.Future;
import stx.async.Promise;
import tink.core.Error;

interface Directory{
  public function set(obj:{path:Path, ?modes:Modes}):Future<Maybe<Error>>;
  public function del(path:Path):Future<Error>;
  public function readdir(path:Path):Promise<Array<String>>;
}
