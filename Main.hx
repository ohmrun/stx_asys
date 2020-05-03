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
		var cwd 	= new Cwd();
		var host 	= LocalHost.unit().toHasDevice();
		cwd.pop()
			.process((dir:Directory) -> dir.into(['src', 'main', 'haxe', 'stx', 'fs']))
			.reframe()
			.arrange(Directory._.tree)
			.evaluation()
			.context(
				host,
				(x) -> handle_term(x), 
				(x) -> trace(x)
			).submit();
		#if test
		// utest.UTest.run(cast new stx.asys.core.pack.Test().deliver().elide());
		// utest.UTest.run(cast new stx.asys.pack.Test().deliver().elide());
		#end
		// haxe.EntryPoint.run();
	}
	static function handle_term(x : Term<Entry>){
		var jsonic = x.toJsonic();
		var string = haxe.Json.stringify(jsonic, ' ');
		trace(__.show(x.toString()));
	}
}
