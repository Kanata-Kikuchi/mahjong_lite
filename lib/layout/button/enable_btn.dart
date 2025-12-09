import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class EnableBtn extends StatelessWidget {
  const EnableBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.bold,
    this.red,
    super.key,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool? bold;
  final bool? red;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: enabled ? onTap : null,
      child: Text(
        label,
        style: (){
          if (enabled) {
            if (red ?? false) {
              if (bold ?? false) {
                return MahjongTextStyle.buttonBackBold;
              } else {
                return MahjongTextStyle.buttonBack;
              }
            } else {
              if (bold ?? false) {
                return MahjongTextStyle.buttonNextBold;
              } else {
                return MahjongTextStyle.buttonNext;
              }
            }
          } else {
            return MahjongTextStyle.buttonEnable;
          }
        }()
      )
    );
  }
}