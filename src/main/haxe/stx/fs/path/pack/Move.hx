package stx.fs.path.pack;

/**
  * A parsed token to walk the directory tree.
**/
enum MoveSum{
  Into(name:String);
  From;
}
typedef Move                          = MoveSum;