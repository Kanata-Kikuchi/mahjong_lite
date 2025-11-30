import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class GameResultContent extends ConsumerWidget {
  const GameResultContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final name = ref.watch(playerProvider).map((m) => m.name).toList();
    final score = ref.watch(gameScoreProvider);
    
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