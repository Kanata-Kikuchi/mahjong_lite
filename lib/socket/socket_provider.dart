import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/debug/debug_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// const url = 'ws://localhost:3000'; // vscode.
const url = 'ws://10.0.2.2:3000'; // AndroidStudio.

enum SocketStatus {
  disconnected,
  connecting,
  connected,
}

class SocketController extends Notifier<SocketStatus> {
  WebSocketChannel? _channel;

  WebSocketChannel? get channel => _channel;
  Stream<dynamic>? get stream => _channel?.stream;

  @override
  SocketStatus build() {
    ref.onDispose(() {
      _channel?.sink.close();
      _channel = null;
    });

    return SocketStatus.disconnected;
  }

  Future<void> connect() async {
    if (ref.read(debugProvider)) { // debugModeなら.
      _channel = null;
      state = SocketStatus.disconnected;
      return;
    }

    if (state == SocketStatus.connected || state == SocketStatus.connecting) {
      return;
    }

    state = SocketStatus.connecting;

    _channel?.sink.close();
    _channel = WebSocketChannel.connect(Uri.parse(url));

    print('socket_provider.dart/connect()');
    state = SocketStatus.connected;
  }

  Future<void> disconnect() async {
    _channel?.sink.close();
    _channel = null;
    print('socket_provider.dart/disconnected()');
    state = SocketStatus.disconnected;
  }

  Future<void> reconnect() async {
    print('socket_provider.dart/reconnect()');
    await disconnect();
    await connect();
  }

  void send(Map<String, dynamic> msg) {
    final ch = _channel;
    if (ch == null) return;
    ch.sink.add(jsonEncode(msg));
  }
}

// main の initState の中で初connect.
final socketProvider = NotifierProvider<SocketController, SocketStatus>(SocketController.new);