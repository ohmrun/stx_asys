package stx.fail;

import stx.fs.path.pack.Raw;

@:using(stx.fail.PathParseFailure.PathParseFailureLift)
enum PathParseFailure{
  //E_Path_Parse_Parse
  E_PathParse_UnexpectedToken(token:Token,raw:Raw);
  //MalformedSource
  E_PathParse_ParseErrorInfo(v:ParseErrorInfo);
  E_PathParse_EmptyInput;
  E_PathParse_MalformedRaw(raw:Raw);

  E_PathParse_NoHeadNode;
  E_PathParse_MisplacedHeadNode;
  E_PathParse_UnexpectedDenormalisedPath(raw:Raw);
  E_PathParse_UnexpectedFileInDirectory(raw:Raw);
  E_PathParse_ExpectedRelativePath(raw:Raw);
  E_PathParse_NoFileFoundOnAttachment(raw:Raw);
  E_PathParse_NoFileOnPath(raw:Raw);
}
class PathParseFailureLift{
  static public function toPathFailure(self:PathParseFailure):PathFailure{
    return E_Path_PathParse(self);
  }
  static public function toFsFailure(self:PathParseFailure):FsFailure{
    return self.toPathFailure().toFsFailure();
  }
  static public function toASysFailure(self:PathParseFailure):ASysFailure{
    return self.toPathFailure().toFsFailure().toASysFailure();
  }
}