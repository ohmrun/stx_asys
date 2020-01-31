package stx.asys.core.head.data;

enum SysFailure{
  EnvironmentVariablesInaccessible;
  SubSystem(err:Dynamic);
}