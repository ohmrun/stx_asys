import haxe.MainLoop;
import haxe.MainLoop.MainEvent;

using stx.Nano;
using jali.Pack;
using stx.show.Lift;
using stx.asys.Pack;
using stx.Fs;
using stx.fs.Path;

class Main {
	static function main() {
		trace('stx_asys');
		
		#if test
			utest.UTest.run(cast new stx.asys.pack.Test().deliver());
		#end
	}
	static function handle_term(x : Jali<Entry>){
		var jsonic = x.toJsonic();
		var string = haxe.Json.stringify(jsonic, ' ');
		trace(__.show(x.toString()));
	}
}
