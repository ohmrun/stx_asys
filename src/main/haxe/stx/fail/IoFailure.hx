package stx.fail;

enum IoFailureSum{
  E_Io_Subsystem(e:haxe.io.Error);
  E_Io_TypeError;
  E_Io_SourceNotFound;
  E_Io_EndOfFile;
  E_Io_UnsupportedValue;
  E_Io_Digest(digest:Digest);
  E_Io_Exhausted(retry:Retry,no_value_found:Bool);
}

@:transitive abstract IoFailure(IoFailureSum) from IoFailureSum to IoFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:IoFailureSum):IoFailure return new IoFailure(self);

  public function prj():IoFailureSum return this;
  private var self(get,never):IoFailure;
  private function get_self():IoFailure return lift(this);
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
