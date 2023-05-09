package stx.io.file;

/**
 * Represents a response to a `FileInputRequest`
 */
enum FileInputResponse{
  FResInput(ireq:InputResponse);
  FResTell(v:Int);
  FReqEof(b:Bool);
}

