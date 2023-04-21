package stx.assert.eq.term.fs.path;

class Track<T> extends stx.assert.eq.term.Base<stx.fs.path.Track>{
  final inner : Eq<StdString>;
  public function new(){
    super();
    this.inner = Eq.String();
  }
  public function comply(lhs:stx.fs.path.Track,rhs:stx.fs.path.Track) {
    return Eq.Cluster(inner).comply(lhs,rhs);
  }
}