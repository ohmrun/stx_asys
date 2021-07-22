package stx.proc;

typedef ThreadDef       = Coroutine<ThreadInput,ThreadOutput,Noise,ASysFailure>;
typedef ThreadReadPush  = Dynamic -> Report<ASysFailure>;

class EventLoop<T>{
  public function run(){
    while(true){

    }
  }
  public function wait(){
    var message : T = StdThread.readMessage(true);
  }
  public function push(handler:T->Void){}
}
abstract Thread(ThreadDef) from ThreadDef to ThreadDef{
  public function new(self) this = self;
  static public function unit(){
    var thread = null;

    return __.hold(
      Provide.fromFunXR(
        () -> {
          thread = StdThread.create();
          return __.tran(
            function rec(ipt:ThreadInput){
              switch(ipt){
                case TI_Read(block)     : 
                  var msg = thread.readMessage(block);
                  __.emit(msg,__.tran(rec));
                case TI_Send(message)   :
                  thread.sendMessage(message);
                  __.tran(rec);
                case TI_Quit:
                  __.stop();
              }
            }
          );
        }
      )
    );
  }
}
enum ThreadDoable{
  TD_Block(block:Void->Void);
  TD_Receive(res:Dynamic->Res<Bool,Dynamic>);//true if was successful
}
enum ThreadInput{
  TI_Task(task:ThreadDoable);
  TI_Send(message:Dynamic);
  TI_Quit;
}
enum ThreadOutput{
  TI_Message(message:Dynamic);
}
class ThreadTest{

}