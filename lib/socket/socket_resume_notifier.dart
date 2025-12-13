import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/socket/data/socket_boot_provider.dart';
import 'package:mahjong_lite/socket/data/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_listening_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_resume_enabled_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/socket/data/socket_roomid_provider.dart';

// main の build のなかで ref.watch.
class SocketResumeNotifier extends Notifier<void> {
  bool _sent = false;
  ProviderSubscription<SocketStatus>? _statusSub;
  ProviderSubscription<String?>? _roomIdSub;
  ProviderSubscription<String?>? _playerIdSub;
  ProviderSubscription<BootRoute>? _bootSub;


  @override
  void build() {
    void trySend() {
      if (_sent) return;

      final status = ref.read(socketProvider);
      if (status != SocketStatus.connected) return;

      final listening = ref.read(socketListeningProvider);
      if (!listening) return;

      final resumeEnabled = ref.read(socketResumeEnabledProvider);
      if (!resumeEnabled) return;

      final roomId = ref.read(socketRoomIdProvider);
      final playerId = ref.read(socketPlayerIdProvider);
      if (roomId == null || playerId == null) return;

      ref.read(socketProvider.notifier).send({
        'type': 'resume_room',
        'payload': {'roomId': roomId, 'playerId': playerId},
      });

      // print('socket_resume_notifier.dart/success: trySend()');
      _sent = true;
    }

    void reset() {
      // print('socket_resume_notifier.dart/reset()');
      _sent = false;
    }

    _statusSub = ref.listen<SocketStatus>(socketProvider, (prev, next) {
      if (next == SocketStatus.connected) {
        trySend();
      } else {
        reset();
      }
    });

    _bootSub = ref.listen<BootRoute>(socketBootRouteProvider, (prev, next) {
      // waiting -> room/share に確定したら、次回の復帰に備えて解除できるようにする.
      if (next != BootRoute.waiting) {
        _sent = false;
      }
    });

    _roomIdSub = ref.listen<String?>(socketRoomIdProvider, (prev, next) {
      if (next == null) reset();
      trySend();
    });

    _playerIdSub = ref.listen<String?>(socketPlayerIdProvider, (prev, next) {
      if (next == null) reset();
      trySend();
    });

    trySend();

    ref.onDispose(() {
      _statusSub?.close();
      _roomIdSub?.close();
      _playerIdSub?.close();
      _bootSub?.close();
    });
  }
}

// main の build のなかで ref.watch.
final socketResumeProvider = NotifierProvider<SocketResumeNotifier, void>(SocketResumeNotifier.new);