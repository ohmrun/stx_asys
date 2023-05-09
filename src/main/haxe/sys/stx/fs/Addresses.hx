package sys.stx.fs;

class Addresses{
  @:noUsing static public function lift(self:AddressDef):Address{
    return Address.lift(self);
  }
  static public function is_directory(self:AddressDef){
    return Attempt.fromFun1Upshot(
      (state:HasDevice) -> {
        return try{
          final canonical = lift(self).canonical(state.device.sep);
          final is_dir    = sys.FileSystem.isDirectory(canonical);
          __.accept(is_dir); 
        }catch(e:Dynamic){
          //trace(e);
          __.reject(__.fault().of(E_Fs_DirectoryNotFound(null)));
        }
      }
    );
  }
}