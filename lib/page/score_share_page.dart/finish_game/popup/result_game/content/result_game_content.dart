import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final order = [
  '1着',
  '2着',
  '3着',
  '4着'
];

class ResultGameContent extends ConsumerWidget {
  const ResultGameContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final sortList = ref.watch(gameScoreProvider);

    if (sortList.length == 1) {
      
      return SizedBox.shrink();
       /* 
       ポップアップを閉じた瞬間にsortListが減るため一瞬エラーが出るから
       <sortList.length == 1> この条件でエラー回避のために
       <SizedBox.shrink()> を用意。UIには表示されるものではない。
       */
      
    } else {

      final name = [
        sortList[sortList.length - 2].score1st!.$1,
        sortList[sortList.length - 2].score2nd!.$1,
        sortList[sortList.length - 2].score3rd!.$1,
        sortList[sortList.length - 2].score4th!.$1
      ];

      final score = [
        sortList[sortList.length - 2].score1st!.$3,
        sortList[sortList.length - 2].score2nd!.$3,
        sortList[sortList.length - 2].score3rd!.$3,
        sortList[sortList.length - 2].score4th!.$3
      ];
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${order[i]}  ${name[i]}',
                style: MahjongTextStyle.choiceLabelL,
              ),
              Text(
                score[i],
                style: MahjongTextStyle.choiceLabelL,
              )
            ],
          );
        })
      );

    }
  }
}