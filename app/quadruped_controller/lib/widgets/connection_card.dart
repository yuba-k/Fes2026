import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  final bool status;
  final ValueChanged<bool> onChanged;

  const ConnectionCard({
    super.key,
    required this.status,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context){
    return Card(
              child: SwitchListTile(
                secondary: Icon(
                  status ? Icons.link : Icons.link_off,
                ),
                title: const Text("接続状態"),
                subtitle: Text(
                  status ? "Connected" : "Disconnected",
                ),
                value: status,
                onChanged: onChanged,
              ),
            );
  }
}