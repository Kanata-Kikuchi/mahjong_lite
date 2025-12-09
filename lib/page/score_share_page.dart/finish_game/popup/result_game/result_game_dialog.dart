import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/popup/result_game/content/result_game_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ResultGameDialog extends ConsumerWidget {
  const ResultGameDialog({
    required this.resultNameList,
    required this.resultScoreList,
    super.key
  });

  final List<String> resultNameList;
  final List<String> resultScoreList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final game = ref.watch(gameProvider.notifier);
    final oka = ref.watch(ruleProvider).oka!.label;
    final uma = ref.watch(ruleProvider).uma!.label;

    return PopupContent(
      title: game.string(),
      anotation: 'ウマ: $uma   オカ: $oka',
      body: ResultGameContent(
        resultNameList: resultNameList,
        resultScoreList: resultScoreList,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
            child: Text(
              '次の試合',
              style: MahjongTextStyle.buttonNext,
            ),
            onPressed: () {
              Navigator.pop(context, true);
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