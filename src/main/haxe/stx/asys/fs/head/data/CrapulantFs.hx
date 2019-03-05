package stx.asys.fs.head.data;

interface Fs{
  public function rename(obj:{prev:String, next:String}):Future<Error>;

  //can't think of a reason for this
  //public function truncate(obj:{path:Path, len:Int}):Future<Error>;

  //not for windows
  //public function chown(obj:{path:Path, uid:Int, gid:Int}):Future<Error>;

  //not for windows
  //public function chmod(obj:{path:Path, mode:Modes}):Future<Error>;

  /**
    The lchmod system call is similar to chmod but does not follow symbolic links.
  **/
  //not cross platform *cough*
  //public function lchmod(obj:{path:Path, mode:Modes}):Future<Error>;
  public function stat(path:String):Promise<Dynamic>;

  /**
    Is identical to stat(), except that if path is a symbolic link, then the link itself is stat-ed, not the file that it refers to.
  **/
  //not for windows
  //public function lstat(path:String):Promise<Stats>;

  /**
    A hardlink isn't a pointer to a file, it's a directory entry (a file) pointing to the same inode.
    Even if you change the name of the other file, a hardlink still points to the file.
    If you replace the other file with a new version (by copying it), a hardlink will not point to the new file.
  **/
  //not for windows
  //public function link(obj:{src:Path, dst:Path}):Future<Error>;

  //not for windows
  //public function symlink(obj:{src:Path, dst:Path, type:String}):Future<Error>;

  /**
    Returns the value of a symbolic link, if symbolic links are implemented.
  **/
  //not for windows
  //public function readlink(src:Path):Promise<Path>;

  //might be useful?
  //public function path(obj:{path:String, cache:StringMap<Dynamic>}):Promise<Path>;

  public function unlink(path:String):Future<Error>;
  public function open(obj:{path:String, flags:Flags, ?mode:Modes}):Promise<File>;

  //not cross platform *hack* *gasp*
  //public function utimes(obj:{path:String, atime:Date, mtime:Date}):Future<Error>;
}
