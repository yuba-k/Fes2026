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
    await _socket?.close();
    _socket = null;
    _connected = false;
    print("Disconnected");
  }

  Future<void> send(String command) async{
    if (!_connected){
      print("Not Connected");
      return;
    }
    try{
      _socket?.write("$command\n");
      await _socket?.flush();
      print("send: $command");
    }catch(e){
      print("Send Failed: $e");
      _connected = false;
    }
  }
}