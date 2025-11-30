import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/layout/button/next_btn.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/layout/score_box.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/extra_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/input_round.dart';
import 'package:mahjong_lite/page/score_share_page.dart/next_game/next_game.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ScoreSharePage extends ConsumerWidget {
  ScoreSharePage({super.key});

  final List<String> zikaze = [
    '東',
    '南',
    '西',
    '北'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final players = ref.watch(playerProvider);
    final game = ref.watch(gameProvider);
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
                          ? NextGame()
                          : InputRound()
                          // : NextGame()
                    ),
                    ScoreBox( // top.
                      width: w / 3,
                      height: h / 3 - 20,
                      zikaze: zikaze[players[2].zikaze],
                      name: players[2].name,
                      score: players[2].score,
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
                      height: h / 3 - 20,
                      zikaze: zikaze[players[3].zikaze],
                      name: players[3].name,
                      score: players[3].score,
                      host: players[3].zikaze == 0
                    ),
                    Text( // ゲーム数表記.
                      '第$game試合',
                      style: MahjongTextStyle.scoreAnotation
                    ),
                    ScoreBox( // right.
                      width: w / 3,
                      height: h / 3 - 20,
                      zikaze: zikaze[players[1].zikaze],
                      name: players[1].name,
                      score: players[1].score,
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
                      child: BackBtn(
                        label: 'ルーム消去',
                        onTap: () {}
                      )
                    ),
                    ScoreBox( // bottom.
                      width: w / 3,
                      height: h / 3 - 20,
                      zikaze: zikaze[players[0].zikaze],
                      name: players[0].name,
                      score: players[0].score,
                      host: players[0].zikaze == 0
                    ),
                    SizedBox( // 局内容・試合履歴.
                      width: w / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NextBtn(
                            label: '局内容',
                            onTap: () => Navigator.pushNamed(context, '/content')
                          ),
                          const SizedBox(width: 20),
                          NextBtn(
                            label: '試合履歴',
                            onTap: () => Navigator.pushNamed(context, '/history')
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