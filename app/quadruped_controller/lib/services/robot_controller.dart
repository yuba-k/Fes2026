import '../services/wifi_service.dart';
class RobotController {
  final WifiService communication = WifiService();
  void moveForward(){
    communication.send("F");
  }
  void moveBackward(){
    communication.send("B");
  }
  void turnLeft(){
    communication.send("L");
  }
  void turnRight(){
    communication.send("R");
  }
  void stop(){
    communication.send("S");
  }
}