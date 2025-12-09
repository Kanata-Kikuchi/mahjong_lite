import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ScoreBox extends StatelessWidget {
  const ScoreBox({
    required this.width,
    required this.height,
    required this.zikaze,
    required this.name,
    required this.score,
    required this.host,
    super.key
  });

  final double width;
  final double height;
  final String zikaze;
  final String name;
  final int score;
  final bool host;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: host
            ? CupertinoColors.systemBlue.withOpacity(0.2)
            : CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  zikaze,
                  style: MahjongTextStyle.scoreLabel
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: MahjongTextStyle.scoreAnotation
                )
              ],
            ),
            Text(
              score.toString(),
              style: MahjongTextStyle.score,
            )
          ],
        )
      )
    );
  }
}