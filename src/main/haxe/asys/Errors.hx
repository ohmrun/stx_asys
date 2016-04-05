package asys;

import tink.core.Error;

class Errors{
 static public inline function not_implemented(){
  return new tink.core.Error(NotImplemented,'function not implemented');
 }
 static public inline function internal_error(?e:Dynamic){
  return tink.core.Error.withData(ErrorCode.InternalError,'internal error',e);
 }
}