import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  const Joystick({super.key, required this.size, required this.onChanged});
  final double size;
  final void Function(double x, double y) onChanged;

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick>{
  Offset _knob = Offset.zero;
  double get _knobSized => widget.size / 3;

  void _update(Offset p){
    final center = Offset(widget.size/2, widget.size/2);
    final maxR = widget.size/2-_knobSized/2;
    var v = p - center;
    if(v.distance > maxR){
      v = v * maxR / v.distance;
    }
    setState(() {
      _knob = v;
    });
  }

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width:widget.size,
      height: widget.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (d) => _update(d.localPosition),
        onPanUpdate: (d) => _update(d.localPosition),
        child: Stack(
          children:[
            Container(
              decoration:BoxDecoration(
                shape:BoxShape.circle,
                color:Colors.grey.shade300
              ),
            ),
            Positioned(
              left: widget.size / 2 - _knobSized / 2 + _knob.dx,
              top: widget.size / 2 - _knobSized / 2 + _knob.dy,
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
      )
    );
  }
}