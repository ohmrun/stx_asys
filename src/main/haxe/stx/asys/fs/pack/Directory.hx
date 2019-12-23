package stx.asys.fs.pack;

#if node
  #error "not implemented";
#else
  typedef Directory<T:Projectable<Certainty>> = stx.asys.fs.pack.haxe.Directory<T>;
#end