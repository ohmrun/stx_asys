package stx.io.file;

/**
 * Represents a request for to input into a file.
 */
enum FileInputRequest{
  FIReqInput(ireq:InputRequest);
  FIReqSeek(p:Int,fs:FileSeek);
  FIReqTell;
  FIReqEof;
}