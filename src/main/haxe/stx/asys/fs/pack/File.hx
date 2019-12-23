package stx.asys.fs.pack;

#if hxnodejs
  //typedef File = stx.asys.fs.pack.node.File;
  #error "not implemented"
#else
  typedef File<T:Projectable<Certainty>> = stx.asys.fs.pack.haxe.File<T>;
#end