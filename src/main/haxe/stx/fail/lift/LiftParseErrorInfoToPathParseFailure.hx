package stx.fail.lift;

import stx.fail.PathParseFailure;

class LiftParseErrorInfoToPathParseFailure{
  static public function toPathParseFailure(e:ParseFailure):PathParseFailure{
    return E_PathParse_ParseErrorInfo(e);
  } 
}