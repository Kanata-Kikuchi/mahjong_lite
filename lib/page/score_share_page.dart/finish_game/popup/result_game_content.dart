import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ResultGameContent extends ConsumerWidget {
  const ResultGameContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final name = ref.watch(playerProvider).map((m) => m.name).toList();
    final sortList = ref.watch(gameScoreProvider.notifier).sortInitial();

    if (sortList.length == 1) {
      
      return SizedBox.shrink();
      
    } else {

      final score = [
        sortList[sortList.length - 2].score1st!.$2,
        sortList[sortList.length - 2].score2nd!.$2,
        sortList[sortList.length - 2].score3rd!.$2,
        sortList[sortList.length - 2].score4th!.$2
      ];
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                name[i],
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