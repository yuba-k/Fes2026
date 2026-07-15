import 'package:flutter/material.dart';

class ControlPad extends StatelessWidget{
  final VoidCallback onForward;
  final VoidCallback onBackward;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onStop;

  const ControlPad({
    super.key,
    required this.onForward,
    required this.onBackward,
    required this.onLeft,
    required this.onRight,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onForward, 
          child: const Text("前進")
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: onRight,
                child: const Text("右転")
              ),
              OutlinedButton(
                onPressed: onStop,
                child: const Text("停止")
              ),
              OutlinedButton(
                onPressed: onLeft,
                child: const Text("左転")
              )
            ]
          ),
        ),
        OutlinedButton(
          onPressed: onBackward,
          child: const Text("後進")
        )
      ]
    );
  }
}