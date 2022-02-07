package stx.assert.eq.term.fs.path;

class Track<T> implements EqApi<stx.fs.path.pack.Track> extends Clazz{
  final inner : Eq<StdString>;
  public function new(){
    super();
    this.inner = Eq.String();
  }
  public function comply(lhs:stx.fs.path.pack.Track,rhs:stx.fs.path.pack.Track) {
    return Eq.Cluster(inner).comply(lhs,rhs);
  }
}