import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ExtraRound extends ConsumerWidget {
  const ExtraRound({
    super.key
  });

  Widget _dot({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final honba = ref.watch(roundProvider).$2;
    final reach = ref.watch(reachProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row( // リーチ棒.
          children: [
            // const SizedBox(width: 25), // どうにかする.
            Expanded(
              child: _dot(size: 7, color: CupertinoColors.systemRed)
            ),
            Expanded(
              child: Text(
                '×      $reach',
                style: MahjongTextStyle.scoreAnotation
              )
            )
          ],
        ),
        const SizedBox(height: 25),
        Row( // 本場.
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (_) => _dot(size: 4, color: CupertinoColors.black))
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (_) => _dot(size: 4, color: CupertinoColors.black))
                  )
                ],
              )
            ),
            Expanded(
              child: Text(
                '×      $honba',
                style: MahjongTextStyle.scoreAnotation
              )
            )
          ],
        )
      ],
    );
  }
}