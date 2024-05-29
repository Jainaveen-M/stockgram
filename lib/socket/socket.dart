import 'package:web_socket_client/web_socket_client.dart';

class WebSocketClient {
  final WebSocket _socket;

  WebSocketClient(String url) : _socket = WebSocket(Uri.parse(url));

  Stream get stream => _socket.messages;

  void send(String message) {
    _socket.send(message);
  }

  void close() {
    _socket.close();
  }
}
