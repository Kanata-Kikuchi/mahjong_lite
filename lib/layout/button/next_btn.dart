import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class NextBtn extends StatelessWidget {
  const NextBtn({
    required this.label,
    required this.onTap,
    super.key
  });

  final String label;
  final void Function() onTap;

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
          Text( // ラウンド表記.
            label,
            style: MahjongTextStyle.buttonNext,
          ),
          const Icon(
            CupertinoIcons.right_chevron,
            color: CupertinoColors.activeBlue,
            size: 13,
          )
        ],
      )
    );
  }
}