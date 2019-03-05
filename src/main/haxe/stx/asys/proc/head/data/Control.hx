package stx.asys.proc.head.data;

enum Control<T>{
    Start;
    Stop;
    Reset;
    Abort(?e:Error);
    Message(v:T);
}