package sys.stx.asys;

class System implements SystemApi{
  public function sleep(t):Future<Noise>{
    return Future.irreversible(
      (cb) -> {
        std.Sys.sleep(t);
        cb(Noise);
      }
    );
  }
}