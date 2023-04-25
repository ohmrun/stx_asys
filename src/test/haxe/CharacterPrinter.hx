
class CharacterPrinter{
  static public function main(){
    while(true){
      Sys.sleep(0.5);
      Sys.stdout().writeByte(Math.round(Math.random() * 254));
      Sys.stdout().flush();
    }
  }
}