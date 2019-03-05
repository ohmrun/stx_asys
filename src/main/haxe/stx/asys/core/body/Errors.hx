package stx.asys.core.body;


class Errors{
 static public inline function not_implemented(f:Fault){
  return f.because('function not implemented',NotImplemented);
}
static public inline function internal_error(f:Fault,?e:Dynamic){
  return f.carrying('internal error',e);
}
 static public inline function eof(f:Fault){
   //Fault.EOF
   return f.because("eof");
 }
}