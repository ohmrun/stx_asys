package stx.asys.fs.head.data;

@:enum abstract Flags(String) from String to String{
  /**
   * Open file for reading. An exception occurs if the file does not exist.
   */
  var Read = "r";

  /**
   * Open file for reading and writing. An exception occurs if the file does not exist.
   */
  var ReadWrite = "r+";

  /**
   * Open file for reading in synchronous mode. Instructs the operating system to bypass the local file system cache.
   * This is primarily useful for opening files on NFS mounts as it allows you to skip the potentially stale local cache.
   * It has a very real impact on I/O performance so don't use this flag unless you need it.
   * Note that this doesn't turn fs.open() into a synchronous blocking call. If that's what you want then you should be using fs.openSync()
   */
  var ReadSync = "rs";

  /**
   * Open file for reading and writing, telling the OS to open it synchronously. See notes for 'rs' about using this with caution.
   */
  var ReadWriteSync = "rs+";

  /**
   * Open file for writing. The file is created (if it does not exist) or truncated (if it exists).
   */
  var WriteCreate = "w";

  /**
   * Like 'w' but fails if path exists.
   */
  var WriteCheck = "wx";

  /**
   * Open file for reading and writing. The file is created (if it does not exist) or truncated (if it exists).
   */
  var WriteReadCreate = "w+";

  /**
   * Like 'w+' but fails if path exists.
   */
  var WriteReadCheck = "wx+";

  /**
   * Open file for appending. The file is created if it does not exist.
   */
  var AppendCreate = "a";

  /**
   * Like 'a' but fails if path exists.
   */
  var AppendCheck = "ax";

  /**
   * Open file for reading and appending. The file is created if it does not exist.
   */
  var AppendReadCreate = "a+";

  /**
   * Like 'a+' but fails if path exists.
   */
  var AppendReadCheck = "ax+";
}
