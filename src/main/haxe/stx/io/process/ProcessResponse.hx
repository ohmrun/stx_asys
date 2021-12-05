package stx.io.process;

enum ProcessResponse{
  PResState(state:ProcessState);
  PResReady;
  PResValue(res:Outcome<InputResponse,InputResponse>);
  PResError(raw:Rejection<ProcessFailure>);
}