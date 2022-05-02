package stx.fail;

enum ASysFailureSum{

  E_UnknownDistroName;
  E_EnvironmentVariablesInaccessible;
  E_ASys_SubSystem(err:Dynamic);

  E_ASys_Fs(fs:FsFailure);
}
@:transitive abstract ASysFailure(ASysFailureSum) from ASysFailureSum to ASysFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ASysFailureSum):ASysFailure return new ASysFailure(self);

  public function prj():ASysFailureSum return this;
  private var self(get,never):ASysFailure;
  private function get_self():ASysFailure return lift(this);

  @:from static public function fromFsFailure(self:FsFailure):ASysFailure{
    return E_ASys_Fs(self);
  }
  @:from static public function fromPathFailure(self:PathFailure):ASysFailure{
    return E_ASys_Fs(E_Fs_Path(self));
  }
}