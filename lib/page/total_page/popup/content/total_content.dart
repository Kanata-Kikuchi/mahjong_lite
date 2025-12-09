import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final order = [
  '1st',
  '2nd',
  '3rd',
  '4th'
];

class TotalContent extends ConsumerWidget {
  const TotalContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  

    /*
      横軸 : 第1試合の席順(東 → 南 → 西 → 北)　=> initialName()
      縦軸 : 各試合
    */

    final sumScore = ref.read(gameScoreProvider.notifier).sumScore();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  order[i],
                  style: MahjongTextStyle.choiceLabelL,
                )
              )
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  sumScore[i].$1,
                  style: MahjongTextStyle.choiceLabelL,
                )
              )
            ),
            Expanded(
              flex: 3,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  sumScore[i].$2,
                  style: MahjongTextStyle.choiceLabelL,
                )
              )
            ),
            Expanded(
              flex: 3,
              child: SizedBox.shrink(),
            )
          ],
        );
      })
    );
  }
}