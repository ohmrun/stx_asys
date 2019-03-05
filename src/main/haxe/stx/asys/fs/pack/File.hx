package stx.asys.fs.pack;

#if hxnodejs
  typedef File = stx.asys.fs.pack.node.File;
#else
  typedef File = stx.asys.fs.pack.haxe.File;
#end