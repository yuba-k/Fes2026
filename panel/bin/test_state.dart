import 'package:panel/control_state.dart';

int _failed = 0;

void check(String name, String actual, String expected) {
  final ok = actual == expected;
  if (!ok) _failed++;
  print('${ok ? "OK  " : "NG  "} $name');
  if (!ok) {
    print('     期待: ${expected.replaceAll("\n", "\\n")}');
    print('     実際: ${actual.replaceAll("\n", "\\n")}');
  }
}

void main() {
  final s = ControlState();

  check('初期状態', s.toPacket(), 'C,0,0,0\n');

  s.mode = Mode.remote;
  s.setStick(0, 1);
  check('上いっぱい', s.toPacket(), 'C,1,100,0\n');

  s.setStick(1, 0);
  check('右いっぱい', s.toPacket(), 'C,1,0,100\n');

  s.setStick(0.5, -0.5);
  check('右下の半分', s.toPacket(), 'C,1,-50,50\n');

  s.setStick(2.0, -3.0);
  check('範囲外は100に収める', s.toPacket(), 'C,1,-100,100\n');

  s.stop();
  check('stop()', s.toPacket(), 'C,0,0,0\n');

  s.mode = Mode.auto;
  check('自律モード', s.toPacket(), 'C,2,0,0\n');

  print(_failed == 0 ? '\n全部OK' : '\n$_failed 件NG');
}