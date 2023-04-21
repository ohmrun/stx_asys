package stx.assert.eq.term.fs.path;

class Drive extends stx.assert.eq.term.Base<stx.fs.Path.Drive>{
  public function comply(lhs:stx.fs.Path.Drive,rhs:stx.fs.Path.Drive):Equaled{
    return Eq.Option(Eq.String()).comply(lhs,rhs);
  }
}