import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupContent(
      anotation: '',
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '試合データがすべて消去されます',
              style: MahjongTextStyle.choiceLabelL,
            ),
          ),
          Center(
            child: Text(
              'ルームを削除しますか？',
              style: MahjongTextStyle.choiceLabelL,
            ),
          )
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CancelBtn(
            label: 'はい',
            red: true,
            onTap: () {
              Navigator.pop(context, true);
            }
          ),
          CancelBtn(
            label: 'いいえ',
            onTap: () {
              Navigator.pop(context, false);
            }
          )
        ],
      )
    );
  }
}