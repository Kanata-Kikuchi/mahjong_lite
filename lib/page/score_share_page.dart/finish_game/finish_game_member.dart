import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class FinishGameMember extends StatelessWidget {
  const FinishGameMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text( // ラウンド表記.
          ' 終 局',
          style: MahjongTextStyle.roundTitle,
        ),
        SizedBox.shrink()
      ],
    );
  }
}