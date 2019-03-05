package stx.asys.io.file.head.data;

import stx.asys.io.head.Data.Iota;
import stx.asys.io.head.Data.Peck;

enum Control<T >{
  Cease;
  Issue(v:T);
  Relay;
}