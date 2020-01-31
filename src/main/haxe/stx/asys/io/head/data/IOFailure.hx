package stx.asys.io.head.data;

enum IOFailure{
  Subsystem(e:haxe.io.Error);
  TypeError;
  SourceNotFound;
  EndOfFile;
}

/**
	The possible IO errors that can occur
**/
// enum Error {
// 	/** The IO is set into nonblocking mode and some data cannot be read or written **/
// 	Blocked;

// 	/** An integer value is outside its allowed range **/
// 	Overflow;

// 	/** An operation on Bytes is outside of its valid range **/
// 	OutsideBounds;

// 	/** Other errors **/
// 	Custom(e:Dynamic);
// }
