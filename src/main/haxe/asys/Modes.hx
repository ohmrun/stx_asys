package asys;

import Std.string;
import asys.types.Modes in TModes;

abstract Modes(TModes) from TModes to TModes{
  public function new(v){
    this = v;
  }
  @:to public inline function toString():String{
    return switch (this) {
      case tuple3(a,b,c) : '${string(a)}${string(b)}${string(c)}';
    }
  }
}