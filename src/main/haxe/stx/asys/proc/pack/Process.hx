package stx.asys.proc.pack;

class Process{
    static public function sleep():Sink<Float>{
        function sleeper(float:Seconds,done:Thunk<Noise>){
            #if neko
                Sys.sleep(float);
                done();
            #else
                done();
            #end
        }
        return Wait(
            function recurse(seconds:Float){
                var trg = Future.trigger();
                sleeper(seconds,
                    () -> {
                        trg.trigger(
                            Wait(recurse);
                        );
                    }
                );
                return Hold(trg.asFuture());
            }
        )
    }
}