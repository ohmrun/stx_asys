package stx.asys.pack;

enum ASysFailure{
  UnknownDistroName;
  EnvironmentVariablesInaccessible;
  SubSystem(err:Dynamic);
}