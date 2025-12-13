import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/page/total_page/popup/total_dialog.dart';

class TotalPopup extends ConsumerWidget {
  const TotalPopup({
    super.key
  });

  Future<bool?> totalPopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return const TotalDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => totalPopup(context),
      child: const Icon(
        CupertinoIcons.right_chevron,
        color: CupertinoColors.activeBlue,
        size: 13,
      )
    );
  }
}