package stx.assert.eq.term.fs.path;

class Drive implements EqApi<stx.fs.Path.Drive> extends Clazz{ 
  public function comply(lhs:stx.fs.Path.Drive,rhs:stx.fs.Path.Drive):Equaled{
    return Eq.Option(Eq.String()).comply(lhs,rhs);
  }
}