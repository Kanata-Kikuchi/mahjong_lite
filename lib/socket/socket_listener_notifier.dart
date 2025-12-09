import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/seat_enum.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/socket_enable_join_provider.dart';
import 'package:mahjong_lite/socket/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/socket/socket_roomid_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketListenerNotifier extends Notifier<void> {

  StreamSubscription? _sub;

  @override
  void build() {
    final channel = ref.read(socketProvider);

    _sub = channel.stream.listen((data) {
      final msg = jsonDecode(data);
      final type = msg['type'];
      final payload = msg['payload'];

      switch(type) {
        case 'room_created':
          print('type: room_created を受信');
          ref.read(ruleProvider.notifier).id(payload['roomId']);

          final player = ref.read(playerProvider.notifier);
          final rule = ref.read(ruleProvider);
          ref.read(ruleProvider.notifier).debug();
          if (rule.oka == Oka.none20000 || rule.oka == Oka.oka20_25) { // 点数をセット.
            player.scoreSet(score: 20000);
          } else if (rule.oka == Oka.none25000 || rule.oka == Oka.oka25_30) {
            player.scoreSet(score: 25000);
          } else if (rule.oka == Oka.none30000 || rule.oka == Oka.oka30_35) {
            player.scoreSet(score: 30000);
          } else {
            throw Exception('socket_listener_notifier/switch/rule.oka');
          }
          ref.read(ruleProvider.notifier).debug();
          break;

        case 'room_state':
          print('type: room_state を受信');
          final player = ref.read(playerProvider.notifier);

          for (final p in payload['players']) {  // 名前をセット.
            if (p['seat'] == Seat.ton.name) {
              player.playerIdAndNameSet(playerId: p['playerId'], initial: Seat.ton.number, name: p['name']);
            } else if (p['seat'] == Seat.nan.name) {
              player.playerIdAndNameSet(playerId: p['playerId'], initial: Seat.nan.number, name: p['name']);
            } else if (p['seat'] == Seat.sya.name) {
              player.playerIdAndNameSet(playerId: p['playerId'], initial: Seat.sya.number, name: p['name']);
            } else if (p['seat'] == Seat.pei.name) {
              player.playerIdAndNameSet(playerId: p['playerId'], initial: Seat.pei.number, name: p['name']);
            } else {
              throw Exception('socket_listener_notifier/switch/payload[seat]');
            }
          }
          ref.read(playerProvider.notifier).debug();
          break;

        case 'set_id':
          print('type: set_id を受信');   
          Future.microtask(() async {
            final pref = await SharedPreferences.getInstance();
            await pref.setString('roomId', payload['roomId']);
            await pref.setString('playerId', payload['playerId']);

            ref.read(socketRoomIdProvider.notifier).state = payload['roomId'];
            ref.read(socketPlayerIdProvider.notifier).state = payload['playerId'];
          });
          break;

        case 'game_start':
          print('type: game_start を受信');
          ref.read(socketGameStartProvider.notifier).state = true;
          break;

        case 'success_join':
          print('type: success_join を受信');
          ref.read(socketEnableJoinProvider.notifier).state = true;
          break;

        case 'unknown_room':
          print('type: unknown_room を受信');
          ref.read(socketEnableJoinProvider.notifier).state = false;
          break;

        case 'delete_room':
          print('type: delete_room を受信');
          ref.read(playerProvider.notifier).revise();
          ref.read(ruleProvider.notifier).revise();

          Future.microtask(() async {
            final pref = await SharedPreferences.getInstance();
            await pref.remove('roomId');
            await pref.remove('playerId');

            ref.read(socketRoomIdProvider.notifier).state = null;
            ref.read(socketPlayerIdProvider.notifier).state = null;
          });

          print('case/delete_rrom/もしかしたらreviseのタイミングが怪しい');
          ref.read(socketEnableJoinProvider.notifier).state = false;
          break;

        case 'pullout_player':
          print('type: pullout_player を受信');
          ref.read(playerProvider.notifier).revise();
          ref.read(ruleProvider.notifier).revise();

          Future.microtask(() async {
            final pref = await SharedPreferences.getInstance();
            await pref.remove('roomId');
            await pref.remove('playerId');

            ref.read(socketRoomIdProvider.notifier).state = null;
            ref.read(socketPlayerIdProvider.notifier).state = null;
          });

          ref.read(socketEnableJoinProvider.notifier).state = false;
          break;

        case 'error':
          print('socket_listener_notifier/受信エラー: ${payload['message']}');
          break;

        default:
          throw Exception('socket_listener_notifier/switch/default');
      }
    });

    ref.onDispose(() => _sub?.cancel());
  }
}

final socketListenerProvider = NotifierProvider<SocketListenerNotifier, void>(SocketListenerNotifier.new);