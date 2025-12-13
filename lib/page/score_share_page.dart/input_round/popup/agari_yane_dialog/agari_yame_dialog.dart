import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class AgariYameDialog extends StatelessWidget {
  const AgariYameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupContent(
      anotation: '',
      body: const Center(
        child: Text(
          'アガリ止めしますか？',
          style: MahjongTextStyle.choiceLabelL
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            child: const Text(
              'はい',
              style: MahjongTextStyle.buttonNext,
            ),
            onPressed: (){
              Navigator.pop(context, true);
            }
          ),
          CupertinoButton(
            child: const Text(
              'いいえ',
              style: MahjongTextStyle.buttonCancel,
            ),
            onPressed: (){
              Navigator.pop(context, false);
            }
          )
        ],
      )
    );
  }
}