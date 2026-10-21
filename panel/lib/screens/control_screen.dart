import 'package:flutter/foundation.dart';
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
      appBar: AppBar(
        title: const Text("Robot Control"),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _link.connected,
            builder: (_, connected, _){
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.wifi,
                  color: connected
                    ? Colors.green
                    : Colors.red,
                ),
              );
            }
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "動作モード",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton(
                          segments: [
                            ButtonSegment(value: Mode.stop, label:Text("停止")),
                            ButtonSegment(value: Mode.auto, label:Text("自律")),
                            ButtonSegment(value: Mode.remote, label:Text("遠隔")),
                          ],
                          selected: {_state.mode},
                          onSelectionChanged: (set){
                            setState(() {
                              _state.setMode(set.first);
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ),
                Joystick(
                  size: 280,
                  onChanged: (x, y) {
                    setState(() {
                      _x = x;
                      _y = y; // _xと_yに代入
                      _state.setStick(x, y);
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      label: Text("X ${_x.toStringAsFixed(2)}"),),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text("Y ${_y.toStringAsFixed(2)}"),
                      )
                  ],
                ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _link.connected,
                          builder: (_, connected, _){
                            return Row(
                              children: [
                                Icon(
                                  Icons.circle, 
                                  size: 12,
                                  color: connected
                                    ? Colors.green
                                    : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  connected ? "接続中" : "切断",
                                )
                              ],
                            );
                          }
                        ),
                        ValueListenableBuilder(
                          valueListenable: _link.batteryMv,
                          builder: (_, mv, _){
                            final voltage = mv == null ? 0 : mv/1000;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mv == null
                                    ? "電池：--"
                                    : "電池：${voltage.toStringAsFixed(2)}V"
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: mv == null
                                    ? 0
                                    : ((mv - 7000)/1400).clamp(0.0, 1.0)
                                )
                              ],
                            );
                          }
                        )
                      ]
                    )
                  )
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: 
        FloatingActionButton.extended(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.warning),
          label: const Text("STOP"),
          onPressed: (){
            setState((){
              _state.stop();
            });
          },
        ),
    );
  }
}