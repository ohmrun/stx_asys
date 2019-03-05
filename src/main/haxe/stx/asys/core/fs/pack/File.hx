package asys;

#if hxnodejs
  typedef File = stx.asys.core.fs.pack.node.File;
#else
  typedef File = stx.asys.core.fs.pack.haxe.File;
#end