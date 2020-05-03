package stx.fs.path.pack;

enum PathFailure{
  ParseFailed(pf:PathParseFailure);
  ReachedRoot;
}