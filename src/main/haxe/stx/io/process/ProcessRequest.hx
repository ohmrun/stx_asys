package stx.io.process;

enum ProcessRequest{
  PReqState(?block:Bool);
  PReqInput(req:InputRequest,err:Bool);
  PReqOutput(req:OutputRequest);
}