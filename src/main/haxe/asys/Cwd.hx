package asys;

#if hxnodejs
 typedef Cwd = js.node.asys.Cwd;
#else
 typedef Cwd = sync.asys.Cwd;
#end