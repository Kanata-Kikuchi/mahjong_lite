import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/popup/next_game/content/next_game_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class NextGameDialog extends ConsumerWidget {
  const NextGameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final game = ref.watch(gameProvider.notifier);

    return PopupContent(
      title: game.nextString(),
      anotation: '親決め',
      body: NextGameContent(),
      footer: Center(
        child: CupertinoButton(
          child: const Text(
            '完了',
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