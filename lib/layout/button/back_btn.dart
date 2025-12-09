import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    required this.label,
    required this.onTap,
    this.blue,
    this.bold,
    super.key
  });

  final String label;
  final void Function() onTap;
  final bool? blue;
  final bool? bold;

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
              color: blue ?? false
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.systemRed,
              size: 13,
            )
          ),
          Text(
            label,
            style: blue ?? false
                ? MahjongTextStyle.buttonNext
                : bold ?? false
                    ? MahjongTextStyle.buttonBackBold
                    : MahjongTextStyle.buttonBack
          )
        ],
      )
    );
  }
}