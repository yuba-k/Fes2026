import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  const Joystick({super.key, required this.size, required this.onChanged});
  final double size;
  final void Function(double x, double y) onChanged;

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick>{
  double get _knobSized => widget.size / 3;
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width:widget.size,
      height: widget.size,
      child: Stack(
        children:[
          Container(
            decoration:BoxDecoration(
              shape:BoxShape.circle,
              color:Colors.grey.shade300
            ),
          ),
          Positioned(
            left: widget.size / 2 - _knobSized / 2,
            top: widget.size / 2 - _knobSized / 2,
            child: Container(
              width: _knobSized,
              height: _knobSized,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue
              ),
            ),
          ),
        ]
      ),
    );
  }
}