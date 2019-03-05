package stx.asys.fs.head.data;

enum FilePathHeadNode{
	Up;
	Down(str:String);
	Root(?root:String);
	Rel;
}