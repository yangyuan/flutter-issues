import 'dart:developer';
import 'dart:io';

class Demo {
  static void demo() {
    host().then((_) {
      sendData();
    });
  }

  static Future host() async {
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
    log("host: binded on port 8080");
    server.listen((HttpRequest request) {
      log("host: listen.onData from: ${request.connectionInfo!.remoteAddress}");
      WebSocketTransformer.upgrade(request,
              compression: CompressionOptions.compressionOff)
          .then((WebSocket webSocket) {
        webSocket.listen((data) {
          if (data is List<int>) {
            log("host: WebSocket.onData: size ${data.length}");
          } else {
            log("host: WebSocket.onData: unknown data type");
          }
        });
      });
    });
  }

  static Future sendData() async {
    // Generate 16M data
    // this is one time operation, doesn't impact demo
    var list = Iterable<int>.generate(1024 * 1024 * 16, (int x) => 0).toList();
    var websocket = await WebSocket.connect("ws://localhost:8080",
        compression: CompressionOptions.compressionOff);
      Stopwatch stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(microseconds: 100)); // Give UI a chance to breath
      stopwatch.reset();
      log("client: WebSocket.add: size ${list.length}");
      websocket.add(list);
      log("client: WebSocket.add: size ${list.length} complete in ${stopwatch.elapsedMicroseconds}us");
    }
  }
}
