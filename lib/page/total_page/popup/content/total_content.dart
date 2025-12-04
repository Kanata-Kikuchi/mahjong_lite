import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class TotalContent extends ConsumerWidget {
  const TotalContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  

    /*
      横軸 : 第1試合の席順(東 → 南 → 西 → 北)　=> initialName()
      縦軸 : 各試合
    */

    final initialName = ref.read(playerProvider.notifier).initialName();
    final buf = ref.read(gameScoreProvider.notifier).sumScore();
    final sumScore = [ // (name, score).
      buf.firstWhere((w) => w.$1 == initialName[0]),
      buf.firstWhere((w) => w.$1 == initialName[1]),
      buf.firstWhere((w) => w.$1 == initialName[2]),
      buf.firstWhere((w) => w.$1 == initialName[3])
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                sumScore[i].$1,
                style: MahjongTextStyle.choiceLabelL,
              )
            ),
            Expanded(
              flex: 1,
              child: Text(
                sumScore[i].$2,
                style: MahjongTextStyle.choiceLabelL,
              )
            )
          ],
        );
      })
    );
  }
}