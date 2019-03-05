package stx.asys.proc.pack;

import stx.asys.proc.head.data.Poll in PollT;

abstract Poll(PollT) from PollT{
    public function new(self){
        this = self;
    }
}