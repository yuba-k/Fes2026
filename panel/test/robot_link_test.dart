import 'package:flutter_test/flutter_test.dart';
import 'package:panel/control_state.dart';
import 'package:panel/robot_link.dart';

// 事前に `dart run bin/fake_robot.dart` を起動しておくこと
void main() {
  test('fake_robotと通信できる', () async {
    final state = ControlState()..mode = Mode.remote;
    final link = RobotLink(state);

    expect(link.connected.value, false); // 開始前は未接続

    await link.start('127.0.0.1', 8888);
    state.setStick(0, 1);

    await Future.delayed(const Duration(milliseconds: 800));
    expect(link.connected.value, true, reason: '状態通知を受信していない');
    expect(link.batteryMv.value, 4800);

    link.stop();
  });

  test('相手がいなければ未接続のまま', () async {
    final state = ControlState()..mode = Mode.remote;
    final link = RobotLink(state);

    await link.start('127.0.0.1', 9999); // 誰もいないポート
    await Future.delayed(const Duration(milliseconds: 1500));
    expect(link.connected.value, false);

    link.stop();
  });
}