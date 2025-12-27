import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/debug/debug_provider.dart';
import 'package:mahjong_lite/layout/button/next_btn.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/layout/score_box.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/delete_room/delete_room.dart';
import 'package:mahjong_lite/page/score_share_page.dart/extra_round/extra_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/finish_game_member.dart';
import 'package:mahjong_lite/page/score_share_page.dart/game_rule/game_rule.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/input_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/finish_game.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/input_round_member.dart';
import 'package:mahjong_lite/socket/flag/socket_initiative_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_navigate_root_provider.dart';
import 'package:mahjong_lite/socket/data/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';

final double bottomBtnPadding = 5;

class ScoreSharePage extends ConsumerStatefulWidget {
  const ScoreSharePage({super.key});

  @override
  ConsumerState<ScoreSharePage> createState() => _ScoreSharePageState();
}

final List<String> zikaze = [
  '東',
  '南',
  '西',
  '北'
];

class _ScoreSharePageState extends ConsumerState<ScoreSharePage> {

  ProviderSubscription? _navSub;

  @override
  void initState() {
    super.initState();

    _navSub = ref.listenManual(socketNavigateRootProvider, (prev, next) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false);
    });
  }


  @override
  void dispose() {
    _navSub?.close();
    super.dispose();
  }

  void socketInputRound() { // 局内容が入力されたら送る.
    final roomId = ref.read(ruleProvider).id;
    final round = ref.read(roundProvider);
    final reach = ref.read(reachProvider);
    final gameSet = ref.read(gameSetProvider);
    final roundTable = ref.read(roundTableProvider); // List<RoundTable>.
    final comment = ref.read(reviseCommentProvider);
    final player = ref.read(playerProvider); // List<Player>.

    final commentJson = {
        for (final e in comment.entries)
          e.key.toString(): e.value
      };

    final msg = {
      'type': 'input_round',
      'payload': {
        'roomId': roomId, // String?.
        'round': {
          'kyoku': round.$1, // int.
          'honba': round.$2, // int.
        },
        'reach': reach, // int.
        'gameSet': gameSet, // bool.
        'roundTable': roundTable.map((m) => {
          'kyoku': m.kyoku, // String.
          'honba': m.honba, // String.
          'p0': m.p0, // int?.
          'p1': m.p1, // int?.
          'p2': m.p2, // int?.
          'p3': m.p3, // int?.
          'revise': m.revise
        }).toList(),
        'comment': commentJson, // Map<int, String>.
        'score': player.map((m) => {
          'initial': m.initial, // int.
          'zikaze': m.zikaze, // int.
          'score': m.score // int?.
        }).toList()
      }
    };

    ref.read(socketProvider.notifier).send(msg);
  }

  void initiativeCheck(
  List<List<int>> scoreMemory,
  List<List<(String, int)>> sum,
) {
  final roomId = ref.read(ruleProvider).id;
  if (roomId == null) {
    return;
  }

  if (scoreMemory.isEmpty || sum.isEmpty) {
    return;
  }

  final gameScore = ref.read(gameScoreProvider);
  final players = ref.read(playerProvider); // 東南西北順.

  final msg = {
    'type': 'initiative_check',
    'payload': {
      'roomId': roomId,
      'scoreMemory': scoreMemory,
      'sum': sum.map((game) => game
          .map((m) => {
                'name': m.$1,
                'score': m.$2,
              })
          .toList()).toList(),
      'gameScore': gameScore.map((m) => {
            'game': m.game,
            'time': m.time,
            'score1st': m.score1st == null
                ? null
                : {
                    'name': m.score1st!.$1,
                    'initial': m.score1st!.$2,
                    'score': m.score1st!.$3,
                  },
            'score2nd': m.score2nd == null
                ? null
                : {
                    'name': m.score2nd!.$1,
                    'initial': m.score2nd!.$2,
                    'score': m.score2nd!.$3,
                  },
            'score3rd': m.score3rd == null
                ? null
                : {
                    'name': m.score3rd!.$1,
                    'initial': m.score3rd!.$2,
                    'score': m.score3rd!.$3,
                  },
            'score4th': m.score4th == null
                ? null
                : {
                    'name': m.score4th!.$1,
                    'initial': m.score4th!.$2,
                    'score': m.score4th!.$3,
                  },
          }).toList(),
      'newSeat': players.map((m) => m.playerId).toList(),
    }
  };

  ref.read(socketProvider.notifier).send(msg);
}


  void removeRoom() {
    final roomId = ref.read(ruleProvider).id;

    final msg = {
      'type': 'finish_session',
      'payload': {
        'roomId': roomId,
      }
    };

    ref.read(socketProvider.notifier).send(msg);
  }

  @override
  Widget build(BuildContext context) {

    final players =  ref.watch(playerProvider);
    final gameSet = ref.watch(gameSetProvider);
    bool initiative = ref.watch(initiativeProvider);
    if (ref.read(debugProvider)) {initiative = true;}
    final offset = (){
      final yourId = ref.read(socketPlayerIdProvider);
      if (yourId == null) return 0; // denugMode.

      final your = players.where((w) => w.playerId == yourId).toList();
      if (your.isEmpty) {
        return 0; // room_state or game_state が来ていない.
      }

      return your.first.initial;
    }();
    
    Widget scoreBoxPosition({ // top:2, left:3, right:1, bottom:0
      required double width,
      required double height,
      required int i
    }) {
      if (offset == 1) {
        i = (i + 1) % 4;
      } else if (offset == 2) {
        i = (i + 2) % 4;
      } else if (offset == 3) {
        i = (i + 3) % 4;
      }
      return ScoreBox(
        width: width,
        height: height,
        zikaze: zikaze[players[i].zikaze],
        name: players[i].name ?? '',
        score: players[i].score ?? 0,
        host: players[i].zikaze == 0
      );
    }

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: LayoutPage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox( // ロン・ツモ・流局入力.
                      width: w / 4,
                      child: gameSet // ゲームセットフラグ.
                          ? initiative // 主導権.
                            ? FinishGame(socketInputSend: socketInputRound, socketFinishSend: initiativeCheck)
                            : FinishGameMember()
                          : initiative // 主導権.
                            ? InputRound(socketInputSend: socketInputRound)
                            : InputRoundMember()
                    ),
                    scoreBoxPosition(width: w / 3, height: h / 3 - 10, i: 2),
                    SizedBox( // 供託・本場表記.
                      width: w / 4,
                      child: ExtraRound(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    scoreBoxPosition(width: w / 3, height: h / 3 - 10, i: 3),
                    GameRule(), // ゲーム数表記.
                    scoreBoxPosition(width: w / 3, height: h / 3 - 10, i: 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox( // ルーム消去.
                      width: w / 4,
                      child: initiative // 主導権.
                          ? DeleteRoom(socketRemoveSend: removeRoom)
                          : const SizedBox.shrink()
                    ),
                    scoreBoxPosition(width: w / 3, height: h / 3 - 10, i: 0),
                    SizedBox( // 局内容・試合履歴.
                      width: w / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: bottomBtnPadding),
                            child: NextBtn(
                              label: '局内容',
                              onTap: () => Navigator.pushNamed(context, '/content')
                            ),
                          ),
                          const SizedBox(width: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: bottomBtnPadding),
                            child: NextBtn(
                              label: '試合履歴',
                              onTap: () => Navigator.pushNamed(context, '/history')
                            )
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        )
      )
    );
  }
}