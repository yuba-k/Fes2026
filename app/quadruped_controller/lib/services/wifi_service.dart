class WifiService {
  Future<void> connect() async {
    print("Connection...");
  }

  Future<void> disconnect() async {
    print("Disconnected");
  }

  Future<void> send(String command) async{
    print("send: $command");
  }
}