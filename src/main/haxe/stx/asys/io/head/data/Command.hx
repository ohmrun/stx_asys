package stx.asys.io.head.data;

typedef Command = {
  public var name(default,null):String;
  public var ?args(default,null):Array<String>;
}