package stx.io;

import stx.io.Process;
/**
  Coroutine handler of Process. Takes stdout or stderr values, produces intermediate values of ProcessRequest or O, settling on R.  
**/
typedef Interpreter<O,R> = Coroutine<Outcome<InputResponse,InputResponse>,ProcessRequest,R,ProcessFailure>;