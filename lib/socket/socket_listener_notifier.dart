import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/seat_enum.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/socket_enable_join_provider.dart';
import 'package:mahjong_lite/socket/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/socket_initiative_provider.dart';
import 'package:mahjong_lite/socket/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/socket/socket_roomid_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  < Flutterからの送信 >
    create_room :
      room_page.dart/socketCreateRoom()
      'ルームを作る'を押下したときに発火し、入力した名前とルールを送る

    join_room :
      room_page.dart/socketJoinRoom()
      'ルームに入る'を押下したときに発火し、入力した名前とルームIDを送る

    start_game :
      room_host.dart/startGame()
      'ゲーム開始'を押下したときに発火し、ルームIDを送る

    remove_room :
      room_host.dart/removeRoom()
      'ルーム削除'を押下したときに発火し、ルームIDを送る

    exit_room :
      room_child.dart/exitRoom()
      '退出'を押下したときに発火し、ルームIDとプレイヤーIDを送る

    input_round :
      score_share_page.dart/soketInputRound()
      点数入力のポップアップにおいて'完了'を押下したときに発火し、
      ルームIDとラウンド、リーチ、第何試合、ゲームセットフラグ、局履歴、試合履歴、点数状況を送る

    initiative_check :
      finish_game.dart/initiativeCheck()
      親決めのポップアップにおいて'完了'を押下したときに発火し、新しい席順になったプレイヤーIDを送る
*/

/*
  < Nodejsからの受信 >
    ~ ルーム関連 ~
    room_state :
      server.js/broadcastRoomState()
      サーバー内に保存したルームデータをもとに該当するルームの入室者にルーム情報を送る

    room_created :
      server.js/createRoom()
      'create_room'を受けてルームIDとプレイヤーIDを発行し、サーバー内にルームデータを保存
      broadcastRoomState()を実行する。

    delete_room :
      server.js/removeRoom()
      'remove_room'を受けてサーバー内に保存したルームデータを削除する

    success_join :
      server.js/joinRoom()
      'join_room'を受けて入室順に[nan, sya, pei]を割り当て、プレイヤーIDを発行し、サーバー内にルームデータを保存
      setId()とbroadcastRoomState()を実行する。

    unknwon_room :
      server.js/joinRoom()
      'join_room'を受けてサーバー内にルームデータに該当するルームが存在しない

    pullout_player :
      server.js/pulloutPlayer()
      'exit_room'を受けてサーバー内にルームデータから該当するプレイヤーを削除し整理する

    game_start :
      server.js/startGame()
      'start_game'を受けて入室者にブロードキャストする

    set_id :
      server.js/setId()
      createRoom()とjoinRoom()で実行され、発行したルームIDとプレイヤーIDを送る

    ~ ゲーム関連 ~
    game_state :
      server.js/broadcastGameState()
      'input_round'を受けてinputRound()が実行され、その中で実行される親以外へのブロードキャスト
      ルームIDとラウンド、リーチ、第何試合、ゲームセットフラグ、局履歴、試合履歴、点数状況を送る
*/

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
          ref.read(initiativeProvider.notifier).state = true; // 主導権true.

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
          ref.read(initiativeProvider.notifier).state = false; // 主導権false.
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

        case 'game_state':
          print('type: game_state を受信');
          ref.read(roundProvider.notifier).roundSet(kyoku: payload['round']['kyoku'], honba: payload['round']['honab']);
          ref.read(reachProvider.notifier).reachSet(reach: payload['reach']);
          ref.read(gameSetProvider.notifier).gameSetSet(gameSet: payload['gameSet']);
          ref.read(roundTableProvider.notifier).roundTableSet(roundTable: payload['roundTable']);
          ref.read(reviseCommentProvider.notifier).reviseCommentSet(comment: payload['comment']);
          ref.read(playerProvider.notifier).playerSet(player: payload['score']);
          break;

        case 'game_finish':
          final playerId = ref.read(socketPlayerIdProvider);
          
          if (payload['players'][0]['playerId'] == playerId) {
            ref.read(initiativeProvider.notifier).state = true;
          } else {
            ref.read(initiativeProvider.notifier).state = false;
          }

          ref.read(gameScoreProvider.notifier).gameScoreSet(gameScore: payload['gameScore']);

          /*-------------------------- リセット群 --------------------------*/
          ref.read(playerProvider.notifier).reset(); // 自風と点数.
          ref.read(reachProvider.notifier).reset(); // リーチ棒.
          ref.read(roundProvider.notifier).reset(); // 局と本場.
          ref.read(roundTableProvider.notifier).reset(); // 局内容.
          ref.read(gameSetProvider.notifier).reset(); // 試合終了フラグ.
          ref.read(reviseCommentProvider.notifier).reset(); // 修正コメント.
          /*----------------------------------------------------------------*/
          ref.read(gameProvider.notifier).progress(); // 試合を進める.
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