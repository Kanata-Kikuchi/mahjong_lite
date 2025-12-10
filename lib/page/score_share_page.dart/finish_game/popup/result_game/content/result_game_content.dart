import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final order = [
  '1st',
  '2nd',
  '3rd',
  '4th'
];

class ResultGameContent extends ConsumerWidget {
  const ResultGameContent({
    required this.resultNameList,
    required this.resultScoreList,
    super.key
  });

  final List<String> resultNameList;
  final List<String> resultScoreList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        return Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  resultNameList[i],
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
                  resultScoreList[i],
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