package asys;

#if hxnodejs
  typedef Stat = js.node.asys.Stat;
#else
  typedef Stat = sys.fs.Stats;
#end
