import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class PopupComment extends ConsumerWidget {
  const PopupComment({
    required this.index,
    super.key
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final comment = ref.watch(reviseCommentProvider);

    return PopupContent(
      title: 'コメント',
      anotation: 'コメント',
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: Text(
            comment[index]!, // index : resive した RoundTable の index.
            style: MahjongTextStyle.choiceLabelL,
          )
        )
      ),
      footer: CupertinoButton(
        child: Text(
          '戻る',
          style: MahjongTextStyle.buttonCancel,
        ),
        onPressed: (){
          Navigator.pop(context);
        }
      )
    );
  }
}