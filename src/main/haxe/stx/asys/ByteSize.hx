package stx.asys;

@:enum abstract ByteSize(StdString) from StdString to StdString{
  var I8      = 'i8';

  var I16BE   = 'i16+';
  var I16LE   = 'i16-';
  var UI16BE  = 'ui16+';
  var UI16LE  = 'ui16-';

  var I24BE   = 'i24+';
  var I24LE   = 'i24-';
  var UI24BE  = 'ui24+';
  var UI24LE  = 'ui24-';

  var I32BE   = 'i32+';
  var I32LE   = 'i32-';

  var FBE     = 'fbe';
  var FLE     = 'fle';
  var DBE     = 'dbe';
  var DLE     = 'dle';

  var LINE    = 'ln';
}
