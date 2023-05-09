package stx.asys;

interface DeviceApi{
  public final distro     : Distro;
  public final sep        : Separator;
  public final system     : Option<SystemApi>;
  public final console    : ConsoleApi;
}