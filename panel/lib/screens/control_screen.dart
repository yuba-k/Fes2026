import 'package:flutter/material.dart';
import '../widgets/joystick.dart';
import '../control_state.dart';
import '../robot_link.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final _state = ControlState();
  late final RobotLink _link;

  double _x = 0;
  double _y = 0;

  @override
  void initState() {
    super.initState();
    _state.mode = Mode.remote;
    _link = RobotLink(_state);
    _link.start("127.0.0.1", 8888);

  }

  @override
  void dispose(){
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Joystick(
              size: 200,
              onChanged: (x, y) {
                setState(() {
                  _x = x;
                  _y = y; // _xと_yに代入
                  _state.setStick(x, y);
                });
              },
            ),
            Text('X: ${_x.toStringAsFixed(2)}  Y: ${_y.toStringAsFixed(2)}'),
            ValueListenableBuilder<bool>(
              valueListenable: _link.connected,
              builder: (context, connected, child){
                return Text(connected ? "接続中" : "切断");
              }
            ),
            ValueListenableBuilder(
              valueListenable: _link.batteryMv,
              builder: (context, mv, child){
                return Text(
                  mv == null ? "電池：--" : "電池：${(mv/1000).toStringAsFixed(2)}V",
                );
              }
            )
          ],
        ),
      ),
    );
  }
}