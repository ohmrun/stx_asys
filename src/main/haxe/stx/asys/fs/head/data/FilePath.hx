package stx.asys.fs.head.data;

typedef FilePath = {
              var head : FilePathHeadNode;
              var body : Array<FilePathBodyNode>;
  @:optional  var tail : FileNode;
}