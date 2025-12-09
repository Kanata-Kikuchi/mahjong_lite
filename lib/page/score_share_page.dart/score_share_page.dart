import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/layout/button/next_btn.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/layout/score_box.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/extra_round/extra_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/input_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/finish_game.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

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

  void socketInputRound() {
    final channel = ref.read(socketProvider);

    final roomId = ref.read(ruleProvider).id;
    final round = ref.read(roundProvider);
    final reach = ref.read(reachProvider);
    final gameSet = ref.read(gameSetProvider);
    final roundTable = ref.read(roundTableProvider); // List<RoundTable>.
    final gameScore = ref.read(gameScoreProvider); // List<Game>.
    final player = ref.read(playerProvider); // List<Player>.
    
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
        'gameScore': gameScore.map((m) => {
          'game': m.game, // String.
          'time': m.time, // int.
          'score1st': m.score1st == null // (String, int, String)?.
              ? null
              : {
                  'name': m.score1st!.$1, // String.
                  'score': m.score1st!.$2, // int.
                  'rank': m.score1st!.$3, // String.
                },
          'score2nd': m.score2nd == null // (String, int, String)?.
              ? null
              : {
                  'name': m.score2nd!.$1, // String.
                  'score': m.score2nd!.$2, // int.
                  'rank': m.score2nd!.$3, // String.
                },
          'score3rd': m.score3rd == null // (String, int, String)?.
              ? null
              : {
                  'name': m.score3rd!.$1, // String.
                  'score': m.score3rd!.$2, // int.
                  'rank': m.score3rd!.$3, // String.
                },
          'score4th': m.score4th == null // (String, int, String)?.
              ? null
              : {
                  'name': m.score4th!.$1, // String.
                  'score': m.score4th!.$2, // int.
                  'rank': m.score4th!.$3, // String.
                },
        }).toList(),
        'score': player.map((m) => {
          'initial': m.initial, // int.
          'zikaze': m.zikaze, // int.
          'score': m.score // int?.
        }).toList()
      }
    };

    channel.sink.add(jsonEncode(msg));
  }

  @override
  Widget build(BuildContext context) {

    final players = ref.watch(playerProvider);
    final game = ref.watch(gameProvider.notifier);
    final gameSet = ref.watch(gameSetProvider);

    return CupertinoPageScaffold(
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
                      child: gameSet
                          ? FinishGame()
                          : InputRound()
                    ),
                    ScoreBox( // top.
                      width: w / 3,
                      height: h / 3 - 10,
                      zikaze: zikaze[players[2].zikaze],
                      name: players[2].name!,
                      score: players[2].score!,
                      host: players[2].zikaze == 0
                    ),
                    SizedBox( // 供託・本場表記.
                      width: w / 4,
                      child: ExtraRound(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ScoreBox( // left.
                      width: w / 3,
                      height: h / 3 - 10,
                      zikaze: zikaze[players[3].zikaze],
                      name: players[3].name!,
                      score: players[3].score!,
                      host: players[3].zikaze == 0
                    ),
                    Text( // ゲーム数表記.
                      game.string(),
                      style: MahjongTextStyle.scoreAnotation
                    ),
                    ScoreBox( // right.
                      width: w / 3,
                      height: h / 3 - 10,
                      zikaze: zikaze[players[1].zikaze],
                      name: players[1].name!,
                      score: players[1].score!,
                      host: players[1].zikaze == 0
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox( // ルーム消去.
                      width: w / 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: bottomBtnPadding),
                        child: BackBtn(
                          label: 'ルーム消去',
                          bold: true,
                          onTap: () {
                            Navigator.pushNamed(context, '/room'); // debug用.
                            /*
                            final pref = await SharedPreferences.getInstance();
                            await pref.remove('playerId');
                            await pref.remove('roomId');
                            */
                          }
                        )
                      )
                    ),
                    ScoreBox( // bottom.
                      width: w / 3,
                      height: h / 3 - 10,
                      zikaze: zikaze[players[0].zikaze],
                      name: players[0].name!,
                      score: players[0].score!,
                      host: players[0].zikaze == 0
                    ),
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