import 'dart:async';
import 'dart:convert';
import 'dart:io';

const port = 8888;
const timeoutMs = 500; // これだけ受信がなければ停止扱い
const statusIntervalMs = 200; // 状態通知の間隔（5Hz）
const fakeBatteryMv = 4800;

Future<void> main() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
  print('fake_robot: UDP $port で待ち受け中 (Ctrl+Cで終了)');

  var mode = 0;
  var vx = 0;
  var wz = 0;
  var timedOut = true; // 受信が来るまでは停止扱い
  final sinceLastRx = Stopwatch()..start();
  InternetAddress? peerAddr; // 最後に受信した相手
  int? peerPort;

  // 受信
  socket.listen((event) {
    if (event != RawSocketEvent.read) return;
    final d = socket.receive();
    if (d == null) return;

    final text = utf8.decode(d.data).trim();
    final parts = text.split(',');
    if (parts.length != 4 || parts[0] != 'C') {
      print('不明なパケット: $text');
      return;
    }
    final m = int.tryParse(parts[1]);
    final v = int.tryParse(parts[2]);
    final w = int.tryParse(parts[3]);
    if (m == null || v == null || w == null) {
      print('数値が不正: $text');
      return;
    }

    sinceLastRx.reset();
    peerAddr = d.address;
    peerPort = d.port;
    if (timedOut) {
      print('受信再開');
      timedOut = false;
    }

    // 変化があったときだけ表示する
    if (m != mode || v != vx || w != wz) {
      print('受信: mode=$m vx=$v wz=$w');
    }
    mode = m;
    vx = v;
    wz = w;
  });

  // タイムアウト判定と状態通知
  Timer.periodic(const Duration(milliseconds: statusIntervalMs), (_) {
    if (!timedOut && sinceLastRx.elapsedMilliseconds > timeoutMs) {
      timedOut = true;
      vx = 0;
      wz = 0;
      print('タイムアウト: 受信が${timeoutMs}ms途絶えたので停止 (vx=0 wz=0)');
    }

    final addr = peerAddr;
    final p = peerPort;
    if (addr != null && p != null) {
      try {
        socket.send(utf8.encode('S,$mode,$fakeBatteryMv\n'), addr, p);
      } catch (e) {
        print('状態通知の送信に失敗: $e');
      }
    }
  });
}