import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'control_state.dart';

class RobotLink {
  RobotLink(this.state);
  final ControlState state;

  RawDatagramSocket? _socket;
  Timer? _timer;
  late InternetAddress _target;
  late int _port;

  Future<void> start(String host, int port) async{
    _target = InternetAddress(host);
    _port = port;
    _socket = await RawDatagramSocket.bind(_target, _port);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_){
      String data = state.toPacket();
      _socket?.send(utf8.encode(data), _target, _port);
    });
  }

  Future<void> stop()async{
    _timer?.cancel();
    _socket?.close();
  }
}