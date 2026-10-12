import 'package:flutter/material.dart';
import 'widgets/joystick.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ControlPage()   // ControlPage()
    );
  }
}

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double _x = 0;
  double _y = 0;

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
                });
              },
            ),
            Text('X: ${_x.toStringAsFixed(2)}  Y: ${_y.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}