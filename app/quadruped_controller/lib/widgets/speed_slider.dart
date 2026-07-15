import 'package:flutter/material.dart';

class SpeedSlider extends StatelessWidget{
  final double speed;
  final ValueChanged<double> onChanged;

  const SpeedSlider({
    super.key,
    required this.speed,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                Text("${speed.toInt()}%"),
                Slider(
                  value: speed,
                  onChanged: onChanged,
                  min: 0,
                  max: 100,
                )
              ]
            );
  }
}