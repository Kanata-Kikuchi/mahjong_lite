import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/agari_dialog.dart';
import 'package:mahjong_lite/debug/debug_print_agari.dart';
import 'package:mahjong_lite/page/score_share_page.dart/next_game/game_result_dialog.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class NextGame extends ConsumerWidget {
  const NextGame({
    super.key
  });

  Future<bool?> nextGamePopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return GameResultDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => nextGamePopup(context),   // ← ポップアップが閉じるまで止まる
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text( // ラウンド表記.
            ' 終 局',
            style: MahjongTextStyle.roundTitle,
          ),
          const Icon(
            CupertinoIcons.right_chevron,
            color: CupertinoColors.activeBlue,
            size: 50,
          )
        ],
      )
    );
  }
}