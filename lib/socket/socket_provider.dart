import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const url = 'ws://localhost:3000'; // flutter.
// const url = 'ws://10.0.2.2:3000'; // AndroidStudio.

final socketProvider = Provider<WebSocketChannel>((ref) {
  final channel = WebSocketChannel.connect(
    Uri.parse(url)
  );

  ref.onDispose(() {
    channel.sink.close();
  });

  return channel;
});