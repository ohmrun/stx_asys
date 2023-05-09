package stx.io.file;

/**
 * Represents a request to a `FileOutput`
 */
enum FileOutputRequest{
  FOReqOutput(req:OutputRequest);
  FOReqSeek(p:Int,fs:FileSeek);
  FOReqTell;
}