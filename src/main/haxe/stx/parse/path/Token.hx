package stx.parse.path;

enum TokenSum{
  FPTDrive(name:Option<String>);
  FPTRel;
  FPTUp;
  FPTSep;
  FPTDown(str:String);
  FPTFile(str:String,?ext:String);
}
abstract Token(TokenSum) from TokenSum to TokenSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:TokenSum):Token return new Token(self);

  public function prj():TokenSum return this;
  private var self(get,never):Token;
  private function get_self():Token return lift(this);

  public function canonical(sep:Separator){
    final s = sep.toString();
    return switch(this){
      case FPTDrive(None)       : s;
      case FPTDrive(Some(name)) : 'name:$s';
      case FPTRel               : '.';
      case FPTUp                : '..';
      case FPTSep               : s;
      case FPTDown(str)         : str;
      case FPTFile(str,ext)     : '${str}.${ext}';
    }
  }
}