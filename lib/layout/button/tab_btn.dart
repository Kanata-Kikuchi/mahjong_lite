import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class TabBtn extends StatelessWidget {
  const TabBtn({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key
  });

  final String label;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? CupertinoColors.activeBlue.withOpacity(0.15)
              : CupertinoColors.white,
          borderRadius: BorderRadius.circular(18)
        ),
        child: Text(
          label,
          style: selected ? MahjongTextStyle.tabBlue : MahjongTextStyle.tabGrey
        ),
      ),
    );
  }
}