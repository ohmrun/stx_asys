package stx.parse.path.test.issues;

class Issue1 extends TestCase{
  public function test(async:Async){
    final source = "/mnt/dat/prj/haxe/stx/stx_cli/".reader();
    final parser = new Posix();
    __.ctx(source,
        (ok: stx.ParseResult<String, Array<stx.parse.term.Token>>) -> {
          trace(ok.toString());
          async.done();
        }
      ,no -> {
        trace(no);
        async.done();
      }
    ).load(parser.toFletcher())
     .submit();
  }
}