package stx.asys.core.pack;

import stx.asys.core.head.data.Device in DeviceI;
import stx.asys.fs.head.data.Fs;

class Local implements DeviceI{
  public function new(){
    this.fs       = new stx.asys.fs.pack.Fs();
    this.distro   = Unix;
  }
  public var distro(default,null):Distro;
  public var fs(default,null):Fs;

  public var cwd(get,null):Vouch<CWD,FilePathFailure>;
  private function get_cwd():Vouch<CWD,FilePathFailure>{
    var parser  = this.distro == Windows ? new stx.filepath.pack.parse.Windows() : new stx.filepath.pack.parse.Posix(); 
    var compile = parser.normalized(std.Sys.getCwd());
    return compile;
  };
}