import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/page/game_history_page/popup/content/plot_dialog.dart';

class PlotGame extends StatelessWidget {
  const PlotGame({super.key});

  Future<bool?> plotPopup(BuildContext context) { // 次の試合の場決め.
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return PlotDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => plotPopup(context),
      child: Icon(
        CupertinoIcons.right_chevron,
        color: CupertinoColors.activeBlue,
        size: 13,
      )
    );
  }
}