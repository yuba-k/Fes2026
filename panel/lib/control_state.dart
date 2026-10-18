enum Mode{
  stop, remote, auto
}

class ControlState {
  int vx = 0;//前進量
  int wz = 0;//旋回量
  Mode mode = Mode.stop;
  void setStick(double x, double y){
    vx = (y*100).round().clamp(-100, 100);
    wz = (x*100).round().clamp(-100, 100);
  }
  void stop(){
    vx = 0;
    wz = 0;
    mode = Mode.stop;
  }
  String toPacket(){
    return 'C,${mode.index},$vx,$wz\n'; 
  }
}