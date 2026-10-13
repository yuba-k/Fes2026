import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final host = args.isNotEmpty ? args[0] : '127.0.0.1';
  final port = args.length > 1 ? int.parse(args[1]) : 8888;

  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  final target = InternetAddress(host);

  // 返信（状態通知）を表示する
  socket.listen((event) {
    if (event == RawSocketEvent.read) {
      final d = socket.receive();
      if (d != null) {
        print('受信: ${utf8.decode(d.data).trim()}');
      }
    }
  });

  // 50msごとに5回送る
  for (var i = 0; i < 5; i++) {
    final text = 'C,1,${i * 20},0\n';
    socket.send(utf8.encode(text), target, port);
    print('送信: ${text.trim()}');
    await Future.delayed(const Duration(milliseconds: 50));
  }

  await Future.delayed(const Duration(milliseconds: 300)); // 返信を待つ
  socket.close();
}