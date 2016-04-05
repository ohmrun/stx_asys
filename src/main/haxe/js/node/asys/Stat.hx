package js.node.asys;

import asys.ifs.Stat in IStat;

class Stat implements IStat{
  private var stat : js.node.fs.Stats;
  public function new(stat){
    this.stat = stat;
  }
  public var gid(get,null) : Int;

  private function get_gid():Int{
    return stat.gid;
  }
  /** the user id for the file **/
  public var uid(get,null) : Int;

  private function get_uid():Int{
    return stat.uid;
  }

  /** the last access time for the file (when enabled by the file system) **/
  public var atime(get,null) : Date;

  private function get_atime():Date{
    return stat.atime;
  }
  /** the last modification time for the file **/
  public var mtime(get,null) : Date;

  private function get_mtime():Date{
    return stat.mtime;
  }
  /** the creation time for the file **/
  public var ctime(get,null) : Date;

  private function get_ctime():Date{
    return stat.ctime;
  }
  /** the size of the file **/
  public var size(get,null) : Int;

  private function get_size():Int{
    return stat.size;
  }
  public var dev(get,null) : Int;

  private function get_dev():Int{
    return stat.dev;
  }
  public var ino(get,null) : Int;

  private function get_ino():Int{
    return stat.ino;
  }
  public var nlink(get,null) : Int;

  private function get_nlink():Int{
    return stat.nlink;
  }
  public var rdev(get,null) : Int;

  private function get_rdev():Int{
    return stat.rdev;
  }

  public var mode(get,null) : Int;

  private function get_mode():Int{
    return stat.mode;
  }
}
