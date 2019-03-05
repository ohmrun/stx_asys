package asys;

/**
 * Work around for the INSPECT_MAX_BYTES attribute.
 */
@:native("(require('buffer'))")
extern class BufferConst
{
  /**
   * Number, Default: 50
   * How many bytes will be returned when buffer.inspect() is called. This can be overridden by user modules.
   * Note that this is a property on the buffer module returned by require('buffer'),
   * not on the Buffer global, or a buffer instance.
   */
  static var INSPECT_MAX_BYTES : Int;
}

/**
 * The Buffer class is a global type for dealing with binary data directly. It can be constructed in a variety of ways.
 * @author Eduardo Pons - eduardo@thelaborat.org
 */
@:native("Buffer")
extern class Buffer implements ArrayAccess<Int> /*implements asys.ifs.Buffer*/{
  
}