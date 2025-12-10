import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/popup/game_rule/content/rule_dialog.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class GameRule extends ConsumerWidget {
  const GameRule({super.key});

  Future<bool?> rulePopup(BuildContext context) { // 次の試合の場決め.
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return RuleDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final game = ref.watch(gameProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => rulePopup(context),
      child: Text(
        game.string(),
        style: MahjongTextStyle.scoreAnotation
      )
    );
  }
}