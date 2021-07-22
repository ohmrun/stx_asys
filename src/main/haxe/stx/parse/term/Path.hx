package stx.parse.term;

interface ParseApi{
	public function parse(i:ParseInput<String>):ParseResult<String, Array<Token>>;
}
typedef Base    = stx.parse.path.Base;
typedef Posix   = stx.parse.path.Posix;
typedef Windows = stx.parse.path.Windows; 

enum TokenSum{
  FPTDrive(name:Option<String>);
  FPTRel;
  FPTUp;
  FPTSep;
  FPTDown(str:String);
  FPTFile(str:String,?ext:String);
}

typedef Token             = TokenSum;
typedef PathParseFailure  = stx.fail.PathParseFailure;