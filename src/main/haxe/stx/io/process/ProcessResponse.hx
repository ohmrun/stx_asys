package stx.io.process;

enum ProcessResponse{
  PResBlank;
  PResState(state:ProcessState);
  PResValue(res:Outcome<InputResponse,InputResponse>);
  PResError(raw:Refuse<stx.fail.ProcessFailure>);
  PResOffer(req:ProcessRequest);
}