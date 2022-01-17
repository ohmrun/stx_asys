package stx.io;

enum InputParserStatus{
  InputParser_NeedsMore(?req:InputRequest);
  InputParser_Done;
}