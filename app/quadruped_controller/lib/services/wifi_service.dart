import 'dart:io';
import '../constants/network.dart';
class WifiService {
  Socket? _socket;
  bool _connected = false;

  bool get connected => _connected;

  Future<void> connect() async {
    try{
      _socket = await Socket.connect(
        NetworkConfig.host,
        NetworkConfig.port
      );
      _connected = true;
      print("Connected");
    }catch(e){
      print("Connection Failed: $e");
    }
  }

  Future<void> disconnect() async {
    _socket?.close();
    _socket = null;
    _connected = false;
    print("Disconnected");
  }

  Future<void> send(String command) async{
    _socket?.write(command);
    print("send: $command");
  }
}