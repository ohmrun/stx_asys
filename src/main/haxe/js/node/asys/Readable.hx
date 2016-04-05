package asys.nodejs;

class Readable{
  //var read          : Dynamic;  //([size])
  //var setEncoding   : Dynamic;  //(encoding)  
  public function pipe(destination:WritableStream,options:Dynamic,end:Boolean):Void{
    
  }
  var unpipe        : Dynamic;  //([destination])
  var unshift       : Dynamic;  //(chunk)
  var wrap          : Dynamic;  //(stream)
  
  /**
   * This method will cause the readable stream to resume emitting data events.
   * This method will switch the stream into flowing-mode.
   * If you do not want to consume the data from a stream, but you do want to get to its end event, 
   * you can call readable.resume() to open the flow of data.
   */
  function resume():Void;
  
  /**
   * This method will cause a stream in flowing-mode to stop emitting data events. 
   * Any data that becomes available will remain in the internal buffer.
   * This method is only relevant in flowing mode. When called on a non-flowing stream, it will switch into flowing mode, but remain paused.
   */
  function pause():Void;
  
  
}