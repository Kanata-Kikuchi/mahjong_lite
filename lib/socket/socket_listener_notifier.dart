import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/seat_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/data/socket_boot_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_enable_join_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_initiative_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_listening_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_navigate_root_provider.dart';
import 'package:mahjong_lite/socket/data/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_resume_enabled_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/socket/data/socket_roomid_provider.dart';
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
      score_share_page.dart/initiativeCheck()
      親決めのポップアップにおいて'完了'を押下したときに発火し、新しい席順になったプレイヤーIDを送る

    finish_session :
      score_share_page.dart/removeRoom()
      ルーム削除ポップアップにおいて'はい'を押下したときに発火、
*/

/*
  < Nodejsからの受信 >
    ~ ルームページ関連 ~
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

    ~ ゲームページ関連 ~
    game_state :
      server.js/broadcastGameState()
      'input_round'を受けてinputRound()が実行され、その中で実行される親以外へのブロードキャスト
      ルームIDとラウンド、リーチ、第何試合、ゲームセットフラグ、局履歴、試合履歴、点数状況を送る

    game_finish :
      server.js/broadcastGameFinish()
      'change_seat'を受けてchangeSeat()が実行され、され、その中で実行されるブロードキャスト
      親決め後の情報が送られる

    navi_room :
      server.js/finishSession()
*/

// main の build のなかで ref.watch.
class SocketListenerNotifier extends Notifier<void> {

  StreamSubscription? _sub;
  ProviderSubscription<SocketStatus>? _statusSub;


  @override
  void build() {

    void attach() {
      _sub?.cancel();
      _sub = null;

      final controller = ref.read(socketProvider.notifier);
      final stream = controller.stream;
      _sub = stream?.listen((data) async {
        final msg = jsonDecode(data);
        final type = msg['type'];
        final payload = msg['payload'];

        switch(type) {
          case 'room_created':
            // print('type: room_created を受信');
            ref.read(ruleProvider.notifier).id(payload['roomId']);
            ref.read(initiativeProvider.notifier).state = true; // 主導権true.

            final player = ref.read(playerProvider.notifier);
            final rule = ref.read(ruleProvider);
            if (rule.oka == Oka.none20000 || rule.oka == Oka.oka20_25) { // 点数をセット.
              player.scoreSet(score: 20000);
            } else if (rule.oka == Oka.none25000 || rule.oka == Oka.oka25_30) {
              player.scoreSet(score: 25000);
            } else if (rule.oka == Oka.none30000 || rule.oka == Oka.oka30_35) {
              player.scoreSet(score: 30000);
            } else {
              throw Exception('socket_listener_notifier/switch/rule.oka');
            }
            break;

          case 'room_state':
            // print('type: room_state を受信');
            final player = ref.read(playerProvider.notifier);
            player.roomStateRest();
            
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
            break;

          case 'set_id':
            final pref = await SharedPreferences.getInstance();
            await pref.setString('roomId', payload['roomId']);
            await pref.setString('playerId', payload['playerId']);

            ref.read(socketRoomIdProvider.notifier).state = payload['roomId'];
            ref.read(socketPlayerIdProvider.notifier).state = payload['playerId'];
            break;

          case 'game_start':
            // print('type: game_start を受信');
            ref.read(ruleProvider.notifier).ruleSet(uma: payload['rule']['uma'], oka: payload['rule']['oka'], tobi: payload['rule']['tobi'], syanyu: payload['rule']['syanyu'], agariyame: payload['rule']['agariyame']);
            ref.read(playerProvider.notifier).scoreSet(score: payload['initialScore']);
            ref.read(socketGameStartProvider.notifier).state = true; // ScoreSHarePageに遷移するためのフラグ.

            // print(payload['initialScore']);
            // ref.read(playerProvider.notifier).debug();
            // ref.read(ruleProvider.notifier).debug();
            break;

          case 'success_join':
            // print('type: success_join を受信');
            ref.read(initiativeProvider.notifier).state = false; // 主導権false.
            ref.read(socketEnableJoinProvider.notifier).state = true;
            break;

          case 'unknown_room':
            // print('type: unknown_room を受信');
            ref.read(socketEnableJoinProvider.notifier).state = false;
            break;

          case 'delete_room':
            // print('type: delete_room を受信');
            ref.read(playerProvider.notifier).revise();
            ref.read(ruleProvider.notifier).revise(); // 調整、UX.
          
            final pref = await SharedPreferences.getInstance();
            await pref.remove('roomId');
            await pref.remove('playerId');

            ref.read(socketRoomIdProvider.notifier).state = null;
            ref.read(socketPlayerIdProvider.notifier).state = null;

            ref.read(socketEnableJoinProvider.notifier).state = false;
            break;

          case 'pullout_player':
            // print('type: pullout_player を受信');
            ref.read(playerProvider.notifier).revise();
            ref.read(ruleProvider.notifier).revise();

            final pref = await SharedPreferences.getInstance();
            await pref.remove('roomId');
            await pref.remove('playerId');

            ref.read(socketRoomIdProvider.notifier).state = null;
            ref.read(socketPlayerIdProvider.notifier).state = null;

            ref.read(socketEnableJoinProvider.notifier).state = false;
            break;

          case 'game_state':
            // print('type: game_state を受信');
            ref.read(roundProvider.notifier).roundSet(kyoku: payload['round']['kyoku'], honba: payload['round']['honba']);
            ref.read(reachProvider.notifier).reachSet(reach: payload['reach']);
            ref.read(gameSetProvider.notifier).gameSetSet(gameSet: payload['gameSet']);
            ref.read(roundTableProvider.notifier).roundTableSet(roundTable: payload['roundTable']);
            ref.read(reviseCommentProvider.notifier).reviseCommentSet(comment: payload['comment']);
            ref.read(playerProvider.notifier).playerSet(player: payload['score']);
            break;

          case 'game_finish':
            // print('type: game_finish を受信');
            final yourId = ref.read(socketPlayerIdProvider); // 古い席順.
            ref.read(playerProvider.notifier).newSeatSet(newSeat: payload['newSeat']); // 新しい席順に.
            final hostId = ref.read(playerProvider)[0].playerId; // 新しい席順.
            
            if (hostId == yourId) { // 主導権.
              ref.read(initiativeProvider.notifier).state = true;
            } else {
              ref.read(initiativeProvider.notifier).state = false;
            }

            ref.read(gameScoreProvider.notifier).gameScoreSet(sum: payload['sum'], memory: payload['scoreMemory'], gameScore: payload['gameScore']);

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

          case 'navi_root':
            // print('type: navi_root を受信');

            ref.read(socketResumeEnabledProvider.notifier).state = false;
            ref.read(socketEnableJoinProvider.notifier).state = false;
            ref.read(socketGameStartProvider.notifier).state = false;
            ref.read(initiativeProvider.notifier).state = false;

            ref.read(socketBootRouteProvider.notifier).state = BootRoute.waiting;

            final pref = await SharedPreferences.getInstance();
            await pref.remove('playerId');
            await pref.remove('roomId');

            ref.read(socketRoomIdProvider.notifier).state = null;
            ref.read(socketPlayerIdProvider.notifier).state = null;

            ref.read(agariProvider.notifier).fullReset();
            ref.read(gameProvider.notifier).fullReset();
            ref.read(gameScoreProvider.notifier).fullReset();
            ref.read(gameSetProvider.notifier).fullReset();
            ref.read(playerProvider.notifier).fullReset();
            ref.read(reachProvider.notifier).fullReset();
            ref.read(reviseCommentProvider.notifier).fullReset();
            ref.read(roundProvider.notifier).fullReset();
            ref.read(roundTableProvider.notifier).fullReset();
            ref.read(ruleProvider.notifier).fullReset();

            ref.read(socketNavigateRootProvider.notifier).state++;
            break;

          case 'resume_result':
            // print('type: resume_result を受信');
            ref.read(socketResumeEnabledProvider.notifier).state = false;

            final ok = payload['ok'] == true;
            final boot = payload['boot'];

            if (!ok) {
              final pref = await SharedPreferences.getInstance();
              await pref.remove('roomId');
              await pref.remove('playerId');

              ref.read(socketRoomIdProvider.notifier).state = null;
              ref.read(socketPlayerIdProvider.notifier).state = null;

              ref.read(socketBootRouteProvider.notifier).state = BootRoute.room;
              break;
            }

            final snapshot = payload['snapshot'] as Map<String, dynamic>;

            final rule = snapshot['rule'];
            if (rule is Map) {
              final r = Map<String, dynamic>.from(rule);

              ref.read(ruleProvider.notifier).ruleSet(
                uma: r['uma'] as String,
                oka: r['oka'] as String,
                tobi: r['tobi'] as String,
                syanyu: r['syanyu'] as String,
                agariyame: r['agariyame'] as String,
              );
            }
            final roomId = ref.read(socketRoomIdProvider);
            ref.read(ruleProvider.notifier).id(roomId);

            final init = snapshot['initialScore'];
            if (init is num) {
              ref.read(playerProvider.notifier).scoreSet(score: init.toInt());
            }

            final gameNo = snapshot['gameNo'];
            if (gameNo is int) {
              ref.read(gameProvider.notifier).gameSet(game: gameNo);
            }

            int seatToInitial(String seat) {
              switch (seat) {
                case 'ton': return 0;
                case 'nan': return 1;
                case 'sya': return 2;
                case 'pei': return 3;
                default: return 0;
              }
            }

            final players = snapshot['players'] as List<dynamic>;
            for (final p in players) {
              ref.read(playerProvider.notifier).playerIdAndNameSet(
                playerId: p['playerId'],
                initial: seatToInitial(p['seat']),
                name: p['name'],
              );
            }

            // 席順(東南西北).
            final newSeat = snapshot['newSeat'];
            if (newSeat is List) {
              ref.read(playerProvider.notifier).newSeatSet(newSeat: newSeat);
            }

            // 主導権.
            final yourId = ref.read(socketPlayerIdProvider);
            final hostId = ref.read(playerProvider)[0].playerId;
            ref.read(initiativeProvider.notifier).state = (hostId == yourId);

            // 履歴.
            final history = snapshot['history'];
            if (history != null) {
              ref.read(gameScoreProvider.notifier).gameScoreSet(
                sum: history['sum'],
                memory: history['scoreMemory'],
                gameScore: history['gameScore'],
              );
            }

            // 試合途中の状態(playing のときのみ).
            final game = snapshot['game'];
            if (game != null) {
              ref.read(roundProvider.notifier).roundSet(
                kyoku: game['round']['kyoku'],
                honba: game['round']['honba'],
              );
              ref.read(reachProvider.notifier).reachSet(reach: game['reach']);
              ref.read(gameSetProvider.notifier).gameSetSet(gameSet: game['gameSet']);
              ref.read(roundTableProvider.notifier).roundTableSet(
                roundTable: game['roundTable'],
              );
              ref.read(reviseCommentProvider.notifier).reviseCommentSet(
                comment: game['comment'],
              );
              ref.read(playerProvider.notifier).playerSet(
                player: game['score'],
              );
            }

            // 画面遷移.
            ref.read(socketBootRouteProvider.notifier).state =
                (boot == 'share') ? BootRoute.share : BootRoute.room;
            break;

          case 'error':
            // print('socket_listener_notifier/受信エラー: ${payload['message']}');
            break;

          default:
            // print('socket_listener_notifier/switch/default');
            break;
        }
      },
      onError: (error) {
        // print('socket_listener_notifier: stream error: $error');
        ref.read(socketProvider.notifier).disconnect();
      },
      onDone: () {
        // print('socket_listener_notifier: stream done');
        ref.read(socketProvider.notifier).disconnect();
      },
      cancelOnError: true,
      );
      ref.read(socketListeningProvider.notifier).state = true;
    }

    void detach() {
      _sub?.cancel();
      _sub = null;
      ref.read(socketListeningProvider.notifier).state = false;
    }

    _statusSub = ref.listen<SocketStatus>(socketProvider, (prev, next) { // 状態を監視して、connected になったら attach.
      if (next == SocketStatus.connected) {
        attach();
      } else {
        detach();
      }
    });

    if (ref.read(socketProvider) == SocketStatus.connected) { // 状態を監視して、connected になったら attach.
      attach();
    }

    ref.onDispose(() {
      _statusSub?.close();
      _sub?.cancel();
      ref.read(socketListeningProvider.notifier).state = false;
    });
  }
}

// main の build のなかで ref.watch.
final socketListenerProvider = NotifierProvider<SocketListenerNotifier, void>(SocketListenerNotifier.new);