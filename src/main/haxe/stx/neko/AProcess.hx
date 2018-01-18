package neko;

import neko.vm.Thread;
import sys.io.Process;

class ProcessHelper
{
        static function main()
	{
		var process = run('haxe', ['--help'],
			function (line) Sys.println('stdout: $line'),
			function (line) Sys.println('stderr: $line'),
			function (code) Sys.println('exited with $code'));
		while (true) Sys.sleep(0.1);
	}

	static function run(cmd:String, args:Array<String>,
		onOutput:String -> Void, onError:String -> Void, onExit:Int -> Void):Process
	{
		var process = new Process(cmd, args);
		Thread.create(readSync.bind(process, onOutput, onError, onExit));
		return process;
	}

	static function runSync(cmd:String, args:Array<String>,
		onOutput:String -> Void, onError:String -> Void, onExit:Int -> Void):Void
	{
		var process = new Process(cmd, args);
		readSync(process, onOutput, onError, onExit);
	}

	static function readSync(process:Process,
		onOutput:String -> Void, onError:String -> Void, onExit:Int -> Void):Void
	{
		read(process.stdout, onOutput);
		read(process.stderr, onError);

		Thread.readMessage(true);
		Thread.readMessage(true);

		onExit(process.exitCode());
	}

	static function read(input:haxe.io.Input, output:String ->Void)
	{
		var thread = Thread.create(function(){
			var main = Thread.readMessage(true);
			while (true) try output(input.readLine())
			catch (e:haxe.io.Eof) break;
			main.sendMessage(true);
		});
		thread.sendMessage(Thread.current());
	}
}
