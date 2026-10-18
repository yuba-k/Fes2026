import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'control_state.dart';

class RobotLink {
  RobotLink(this.state);
  final ControlState state;

  RawDatagramSocket? _socket;
  Timer? _timer;
  late InternetAddress _target;
  late int _port;

  final connected = ValueNotifier<bool>(false);
  final batteryMv = ValueNotifier<int?>(null);
  DateTime? _lastRx;

  void _handlePacket(String text){
    var parts = text.trim().split(",");
    if(parts.length == 3 && parts[0] == "S"){
      final mode = int.tryParse(parts[1]);
      final mv = int.tryParse(parts[2]);
      if(mode == null || mv == null) return;
      _lastRx = DateTime.now();
      connected.value = true;
      batteryMv.value = mv;
    }
  }

  Future<void> start(String host, int port) async{
    stop();
    _target = InternetAddress(host);
    _port = port;
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _socket = socket;
    socket.listen((event){
      if(event == RawSocketEvent.read){
        final d = socket.receive();
        if(d != null){
          _handlePacket(utf8.decode(d.data, allowMalformed: true).trim());
        }
      }
    });
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_){
      String data = state.toPacket();
      try{
        _socket?.send(utf8.encode(data), _target, _port);
      } catch(_){}
      final last = _lastRx;
      final lost = last == null || DateTime.now().difference(last) > const Duration(seconds: 1);
      if(lost) connected.value = false;
    });
  }

  void stop(){
    _timer?.cancel();
    _socket?.close();
    connected.value = false;
    _lastRx = null;
  }

  void dispose(){
    stop();
    connected.dispose();
    batteryMv.dispose();
  }
}