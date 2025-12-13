import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class CancelBtn extends StatelessWidget {
  const CancelBtn({
    required this.label,
    required this.onTap,
    this.red,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool? red;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      child: Text(
        label,
        style: red ?? false
            ? MahjongTextStyle.buttonBackBold
            : MahjongTextStyle.buttonCancel
      ),
    );
  }
}