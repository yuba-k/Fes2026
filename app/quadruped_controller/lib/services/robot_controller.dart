import 'wifi_service.dart';

class RobotController {
  final WifiService wifi = WifiService();

  Future<void> connect() async {
    await wifi.connect();
  }

  Future<void> disconnect() async {
    await wifi.disconnect();
  }

  Future<void> moveForward() async {
    await wifi.send("F");
  }

  Future<void> turnRight() async {
    await wifi.send("R");
  }

  Future<void> turnLeft() async {
    await wifi.send("L");
  }

  Future<void> moveBackward() async {
    await wifi.send("B");
  }

  Future<void> stop() async {
    await wifi.send("S");
  }
}