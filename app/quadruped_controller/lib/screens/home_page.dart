import 'package:flutter/material.dart';

import '../widgets/connection_card.dart';
import '../widgets/control_pad.dart';
import '../widgets/speed_slider.dart';
import '../services/robot_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool status = false;
  String moved = "";
  double speed = 0;
  final RobotController robot = RobotController();

  void connect(bool value) => setState(() {
    status = value;
  });
  void front(){
      robot.moveForward();
      setState(() {
        moved = "前進";
    });
  }
  void right() {
    robot.turnRight();
    setState(() {
      moved = "右転";
    });
  } 
  void left() {
    robot.turnLeft();
    setState(() {
      moved = "左転";
    });
  }
  void back(){
    robot.moveBackward();
    setState(() {
      moved = "後進";
    });
  }
  void stop() {
    robot.stop();
    setState(() {
      moved = "停止";
    });
  }
  void changeSpeed(double value) => setState(() {
    speed = value;
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("遠隔操作パネル"),
      ),
      body: Center(
        child: Column(
          children: [
            ConnectionCard(status:status, onChanged: connect,),
            Text(moved),
            ControlPad(
              onForward: front,
               onBackward: back, 
               onLeft: left, 
               onRight: right, 
               onStop: stop
            ),
            SpeedSlider(
              speed: speed, 
              onChanged: changeSpeed,
            )
          ],
        ),
      )
    );
  }
}