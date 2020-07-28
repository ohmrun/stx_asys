package stx.fail;

enum ASysFailure{

  UnknownDistroName;
  E_EnvironmentVariablesInaccessible;
  SubSystem(err:Dynamic);

  E_ASys_Fs(fs:FsFailure);
}