enum Mode{
  sleep, remote, auto, stand
}

class ControlState {
  int vx = 0;//前進量
  int wz = 0;//旋回量
  Mode mode = Mode.sleep;
  void setStick(double x, double y){
    if(mode == Mode.remote){
      vx = (y*100).round().clamp(-100, 100);
      wz = (x*100).round().clamp(-100, 100);
    }else{
      vx = 0;
      wz = 0;
    }
  }
  void stop(){
    vx = 0;
    wz = 0;
    mode = Mode.stand;
  }
  String toPacket(){
    return 'C,${mode.index},$vx,$wz\n'; 
  }
  void setMode(Mode m){
    mode = m;
    if(m == Mode.remote){
      ;
    }else{
      vx = 0;
      wz = 0;
    }
  }
}