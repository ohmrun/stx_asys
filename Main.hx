import haxe.MainLoop;
import haxe.MainLoop.MainEvent;

using stx.Nano;

using stx.show.Lift;
using stx.ASys;
using stx.Fs;
using stx.fs.Path;

using eu.ohmrun.Jali;

class Main {
	static function main() {
		trace('stx_asys');		
		#if (test=="stx_asys")
			utest.UTest.run(cast new stx.asys.pack.Test().deliver());
		#end
	}
}
