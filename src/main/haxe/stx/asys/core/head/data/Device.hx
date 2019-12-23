package stx.asys.core.head.data;

import stx.asys.fs.head.data.Fs in FsI;


interface Device{
  //public var platform(default,null):Platform;
  public var distro(default,null)     : Distro;
  public var fs(default,null)         : FsI;
  public var cwd(get,null)            : Vouch<CWD,FilePathFailure>;
  private function get_cwd()          : Vouch<CWD,FilePathFailure>;   
}