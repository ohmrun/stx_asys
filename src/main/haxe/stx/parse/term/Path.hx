package stx.parse.term;

interface ParseApi{
	public function parse(i:ParseInput<String>):ParseResult<String, Array<Token>>;
}
typedef Base                    = stx.parse.path.Base;
typedef Posix                   = stx.parse.path.Posix;
typedef Windows                 = stx.parse.path.Windows; 

typedef Token                   = stx.parse.path.Token; 
typedef TokenSum                = stx.parse.path.Token.TokenSum; 

typedef PathParseFailure        = stx.fail.PathParseFailure;
typedef PathParseFailureSum     = stx.fail.PathParseFailure.PathParseFailureSum;