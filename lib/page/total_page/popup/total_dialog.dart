import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/page/total_page/popup/content/total_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class TotalDialog extends ConsumerWidget {
  const TotalDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return PopupContent(
      title: '合計',
      anotation: '',
      body: TotalContent(),
      footer: Center(
        child: CupertinoButton(
          child: Text(
            '戻る',
            style: MahjongTextStyle.buttonNext,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          }
        )
      )
    );
  }
}