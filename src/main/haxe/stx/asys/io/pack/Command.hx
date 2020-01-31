package stx.asys.io.pack;

import stx.asys.io.head.data.Command in CommandT;

@:forward abstract Command(CommandT) {
  public function new(self){
    this = self;
  }
}