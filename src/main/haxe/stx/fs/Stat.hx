package stx.fs;

typedef Stat = {
  /** the user group id for the file **/
  public var gid(get,null) : Int;

  public function get_gid():Int;
  /** the user id for the file **/
  public var uid(get,null) : Int;

  public function get_uid():Int;

  /** the last access time for the file (when enabled by the file system) **/
  public var atime(get,null) : Date;

  public function get_atime():Date;
  /** the last modification time for the file **/
  public var mtime(get,null) : Date;

  public function get_mtime():Date;
  /** the creation time for the file **/
  public var ctime(get,null) : Date;

  public function get_ctime():Date;
  /** the size of the file **/
  public var size(get,null) : Int;

  public function get_size():Int;
  public var dev(get,null) : Int;

  public function get_dev():Int;
  public var ino(get,null) : Int;
  
  public function get_ino():Int;
  public var nlink(get,null) : Int;

  public function get_nlink():Int;
  public var rdev(get,null) : Int;

  public function get_rdev():Int;

  public var mode(get,null) : Int;

  public function get_mode():Int;

  //hmmmm
  /*
    function isFile():Bool;
    function isDirectory():Bool;
    function isBlockDevice():Bool;
    function isCharacterDevice():Bool;
    function isSymbolicLink():Bool;
    function isFIFO():Bool;
    function isSocket():Bool;
  */
}