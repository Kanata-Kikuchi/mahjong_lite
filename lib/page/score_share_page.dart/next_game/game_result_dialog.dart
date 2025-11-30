import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/next_game/popup/game_result_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class GameResultDialog extends ConsumerWidget {
  const GameResultDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final game = ref.watch(gameProvider);
    final oka = ref.watch(ruleProvider).oka.label;
    final uma = ref.watch(ruleProvider).uma.label;

    return PopupContent(
      title: '第$game試合',
      anotation: 'ウマ: $uma   オカ: $oka',
      body: GameResultContent(),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            child: Text(
              '完了',
              style: MahjongTextStyle.buttonNext,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }
          ),
          CupertinoButton(
            child: Text(
              'キャンセル',
              style: MahjongTextStyle.buttonCancel,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }
          )
        ],
      ),
    );
  }
}