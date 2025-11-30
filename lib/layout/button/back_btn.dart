import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    required this.label,
    required this.onTap,
    this.blue = false,
    super.key
  });

  final String label;
  final void Function() onTap;
  final bool blue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        mainAxisSize: MainAxisSize.min,
        children: [
          RotatedBox(
            quarterTurns: 90,
              child: Icon(
              CupertinoIcons.right_chevron,
              color: blue
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemRed,
              size: 17,
            )
          ),
          Text( // ラウンド表記.
            label,
            style: blue
                ? MahjongTextStyle.buttonNext
                : MahjongTextStyle.buttonBack
          )
        ],
      )
    );
  }
}