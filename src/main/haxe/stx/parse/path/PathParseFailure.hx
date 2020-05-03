package stx.parse.path;

enum PathParseFailure{
  MalformedSource(v:ParseResult<Dynamic,Dynamic>);
  MalformedRaw(raw:Raw);
  NoHeadNode;
  MisplacedHeadNode;
  UnexpectedDenormalisedPath(raw:Raw);
  UnexpectedFileInDirectory(raw:Raw);
  ExpectedRelativePath(raw:Raw);
  NoFileFoundOnAttachment(raw:Raw);
  NoFileOnPath(raw:Raw);
}