package;

using StringTools;

import asys.os.Linux;
import asys.OS;

import asys.docker.strongloop.StrongPm;

using hx.Maybe;

import stx.Pointwise.toOption as option;

using com.mindrocks.text.InputStream;
using com.mindrocks.text.Parser;

import Type;
using Lambda;

class Run{
  static function main(){
    var tail  = [];
    var args  = Sys.args();
    //trace(Sys.executablePath());

    //todo windows seperator
    if(~/haxelib/g.match(
      Sys.executablePath()
    )||~/\/asys\//g.match(
      Sys.getCwd()
    )){
      tail.push('looks like I\'m being run from haxelib');
      args.pop();
    }
    //tail.push(Sys.environment());
    tail.push('args: $args');

    tail.push(' len: ${args.length}');
    var head : Maybe<String> = args[0];

    args.shift();

    tail.push('apply: $head');

    if(!head.isDefined()){
      tail.push("no arguments provided... exiting");
      Sys.println(tail.join("\n"));
      Sys.exit(-1);
    }
    var parts = head.getOrElse('').split('.');
        //scope "everything" to the asys namespace
        parts.unshift("asys");

    var path = parts.slice(0,parts.length-1).join(".");

    tail.push('path: $path');

    var name  = parts[parts.length-1];

    tail.push('function: $name');
    var parse = new Parser();

    var parsed_args = args.map(
      function(x){
          return try{
            parse.parse(x);
          }catch(e:Dynamic){
            tail.push(e);
            Sys.println(tail.join("\n"));
            Sys.exit(-1);
            null;
          }
      }
    );

    tail.push('args: $args');

    var type : Maybe<Class<Dynamic>> = Type.resolveClass(path);

    tail.push('type? ${type != null ? "ok" : "no"}');

    if(!type.isDefined()){
      tail.push('cannot resolve path: $path.');
      Sys.println(tail.join("\n"));
      Sys.exit(-1);
    }else{
      var v = type.flatMap(
        function(type:Class<Dynamic>){
          tail.push(Type.getClassFields(type).toString());
          var field = Reflect.field(type,name);
          tail.push('field? ${field != null ? "ok" : "no"}');
          return field;
        }
      ).each(
        function(ref){
          tail.push('----------------------');
          //trace(tail.join("\n"));
          Sys.print(Reflect.callMethod(type,ref,parsed_args));
        }
      );
      if(!v.isDefined()){
        tail.push('cannot find path: $head');
        Sys.println(tail.join("\n"));
        Sys.exit(-1);
      }
    }
  }
}

private class Parser{
  public function new(){

  }
  //TODO move main stuff in here to allow other actions
  public function head(str){
    return null;
  }
  public function match(arr:Array<String>){
    var head = head(arr[0]);
  }
  public function parse(str:String):Dynamic{
    return switch(string().or(number().or(json()))()(str.reader()) ){
      case Success(x,xs) :
        if(xs.content.hasNext()){
          throw x;
          null;
        }else{
          switch(x){
            case INumber(f) : f;
            case IJson(v)   : v;
            case IString(s) : s;
          }
        }
      case x:
        throw x;
        null;
    }
  }
  public function number(){
    return Parsers.regexParser(~/\d+?\.?\d*/g).then(Std.parseFloat).then(INumber);
  }
  public function json(){
    return Parsers.regexParser(~/^{.*/g).then(haxe.Json.parse).then(IJson);
  }
  public function string(){
    return Parsers.regexParser(~/.*/g).then(IString);
  }
}

enum Input{
  INumber(f:Float);
  IJson(j:Dynamic);
  IString(s:String);
}
private enum Head{
  StaticCall(type:Class<Dynamic>,method:String,args:Array<Dynamic>);
}
