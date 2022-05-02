package stx.fail;

import stx.fs.path.Raw;

@:using(stx.fail.PathParseFailure.PathParseFailureLift)
enum PathParseFailureSum{
  //E_Path_Parse_Parse
  E_PathParse_UnexpectedToken(token:Token,raw:Raw);
  //MalformedSource
  E_PathParse_ParseErrorInfo(v:stx.parse.core.ParseRefuse);
  E_PathParse_EmptyInput;
  E_PathParse_MalformedRaw(raw:Raw);
  
  E_PathParse_ExpectedEntry(raw:Raw);
  E_PathParse_NoHeadNode;
  E_PathParse_MisplacedHeadNode;
  E_PathParse_UnexpectedDenormalizedPath(raw:Raw);
  E_PathParse_UnexpectedFileInDirectory(raw:Raw);
  E_PathParse_ExpectedRelativePath(raw:Raw);
  E_PathParse_NoFileFoundOnAttachment(raw:Raw);
  E_PathParse_NoFileOnPath(raw:Raw);
}
@:using(stx.fail.PathParseFailure.PathParseFailureLift)
@:transitive abstract PathParseFailure(PathParseFailureSum) from PathParseFailureSum to PathParseFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:PathParseFailureSum):PathParseFailure return new PathParseFailure(self);

  public function prj():PathParseFailureSum return this;
  private var self(get,never):PathParseFailure;
  private function get_self():PathParseFailure return lift(this);

  @:from static public function fromParseErrorInfo(self:stx.parse.core.ParseRefuse){
    return lift(E_PathParse_ParseErrorInfo(self));
  }
}
class PathParseFailureLift{
  static public function toPathFailure(self:PathParseFailureSum):PathFailure{
    return E_Path_PathParse(self);
  }
  static public function toFsFailure(self:PathParseFailureSum):FsFailure{
    return self.toPathFailure().toFsFailure();
  }
  static public function toASysFailure(self:PathParseFailureSum):ASysFailure{
    return self.toPathFailure().toFsFailure().toASysFailure();
  }
}