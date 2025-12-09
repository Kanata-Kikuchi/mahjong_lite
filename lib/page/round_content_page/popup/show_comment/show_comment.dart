import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/page/round_content_page/popup/show_comment/content/popup_comment.dart';

class ShowComment extends ConsumerWidget {
  const ShowComment({
    required this.index,
    super.key
  });

  final int index;

  Future<bool?> showCommentPopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return PopupComment(index: index);
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showCommentPopup(context),
      child: const Icon(
        CupertinoIcons.doc,
        color: CupertinoColors.systemRed,
        size: 13,
      )
    );
  }
}