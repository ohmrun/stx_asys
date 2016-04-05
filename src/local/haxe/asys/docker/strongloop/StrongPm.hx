package asys.docker.strongloop;

class StrongPm{
  static public function run(){

    var args = "run --detach --restart=no --publish 8701:8701 --publish 3001:3001 --publish 3002:3002 --publish 3003:3003 --name strong-pm-container strongloop/strong-pm".split(" ");

    Sys.command("docker",args);
  }
}
