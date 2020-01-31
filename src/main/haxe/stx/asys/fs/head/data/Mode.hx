package stx.asys.fs.head.data;

@:enum abstract Mode(Int){
  var EXEC            = 1;
  var WRITE           = 2;
  var WRITE_EXEC      = 3;
  var READ            = 4;
  var READ_EXEC       = 5;
  var READ_WRITE      = 6;
  var READ_WRITE_EXEC = 7;
}
