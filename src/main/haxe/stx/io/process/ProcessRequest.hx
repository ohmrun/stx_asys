package stx.io.process;

enum ProcessRequest{
  PReqTouch;
  PReqState(?block:Bool);
  PReqInput(req:InputRequest,err:Bool);
  PReqOutput(req:OutputRequest);
}