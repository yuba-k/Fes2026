import 'package:panel/control_state.dart';
import 'package:panel/robot_link.dart';

Future<void> main() async {
  final state = ControlState()..mode = Mode.remote;
  final link = RobotLink(state);

  await link.start('127.0.0.1', 8888);
  print('送信開始');

  state.setStick(0, 1); // 前進いっぱい
  await Future.delayed(const Duration(seconds: 1));

  state.setStick(1, 0); // 右旋回いっぱい
  await Future.delayed(const Duration(seconds: 1));

  state.stop();
  await Future.delayed(const Duration(milliseconds: 500));

  link.stop();
  print('終了');
}