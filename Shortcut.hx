package;

using StringTools;

class Shortcut{
  static public function main(){
    var args      = Sys.args();
    args.unshift('asys');
    args.unshift('run');

    Sys.command(
      'haxelib',
      args
    );
  }
}
