package stx.io;

enum IoFailure{
  Subsystem(e:haxe.io.Error);
  TypeError;
  SourceNotFound;
  EndOfFile;
  UnsupportedValue;
}

/**
	The possible Produce errors that can occur
**/
// enum Error {
// 	/** The Produce is set into nonblocking mode and some data cannot be read or written **/
// 	Blocked;

// 	/** An integer value is outside its allowed range **/
// 	Overflow;

// 	/** An operation on Bytes is outside of its valid range **/
// 	OutsideBounds;

// 	/** Other errors **/
// 	Custom(e:Dynamic);
// }
