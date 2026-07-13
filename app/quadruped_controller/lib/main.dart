import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remoto Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Remoto Controller Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool status = false;
  String moved = "";
  double speed = 0;
  void connect(bool value) => setState(() {
    status = value;
  });
  void front() => setState(() {
    moved = "前進";
  });
  void right() => setState(() {
    moved = "右転";
  }); 
  void left() => setState(() {
    moved = "左転";
  });
  void back() => setState(() {
    moved = "後進";
  });
  void stop() => setState(() {
    moved = "停止";
  });
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
            Card(
              child: SwitchListTile(
                secondary: Icon(
                  status ? Icons.link : Icons.link_off,
                ),
                title: const Text("接続状態"),
                subtitle: Text(
                  status ? "Connected" : "Disconnected",
                ),
                value: status,
                onChanged: connect,
              ),
            ),
            Text(moved),
            OutlinedButton(
              onPressed: front, 
              child: const Text("前進")
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: right,
                    child: const Text("右転")
                  ),
                  OutlinedButton(
                    onPressed: left,
                    child: const Text("左転")
                  )
                ]
              ),
            ),
            OutlinedButton(
              onPressed: back,
              child: const Text("後進")
            ),
            OutlinedButton(
              onPressed: stop,
              child: Text("停止")
            ),
            Column(
              children: [
                Text("${speed.toInt()}%"),
                Slider(
                  value: speed,
                  onChanged: changeSpeed,
                  min: 0,
                  max: 100,
                )
              ]
            )
          ],
        ),
      )
    );
  }
}