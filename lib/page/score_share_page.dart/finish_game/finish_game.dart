import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/next_game_dialog.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/agari_dialog.dart';
import 'package:mahjong_lite/debug/debug_print_agari.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/result_game_dialog.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class FinishGame extends ConsumerWidget {
  const FinishGame({
    super.key
  });

  Future<bool?> resultGamePopup(BuildContext context) { // 誰が何点だったかを表示する.
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return ResultGameDialog();
      }
    );
  }

  Future<bool?> nextGamePopup(BuildContext context) { // 次の試合の場決め.
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return NextGameDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector( // 終局を押したら.
      behavior: HitTestBehavior.opaque,
      onTap: () async {

        /*-----------ここで試合履歴と集計に使うデータをセットする-------------*/
        final game = ref.watch(gameProvider.notifier);
        final uma = ref.watch(ruleProvider).uma;
        final oka = ref.watch(ruleProvider).oka;
        
        final scoreList = ref.read(playerProvider)
            .map((m) => (m.initial, m.score))
            .toList();

        final gameScore = ref.read(gameScoreProvider.notifier);
              gameScore.set(
                game: game.string(),
                nextGame: game.nextString(),
                uma: uma,
                oka: oka,
                score: scoreList
              );
        /*----------------------------------------------------------------*/

        final resultGame = await resultGamePopup(context); // Popup.

        if (resultGame == false) { // キャンセルを押したら.
          gameScore.reset();
          return;
        }

        if (!context.mounted) {return;} // awaitの後にcontextを使うと警告が出るから.

        bool? resultNext;

        if (resultGame == true) { // １個目のポップアップで完了が押されたら.
          resultNext = await nextGamePopup(context); // Popup.
        }

        if (resultNext == true) { // ２個目のポップアップで完了が押されたら.

          /*-------------------------- リセット群 --------------------------*/
          ref.read(playerProvider.notifier).reset(); // 自風と点数.
          ref.read(reachProvider.notifier).reset(); // リーチ棒.
          ref.read(roundProvider.notifier).reset(); // 局と本場.
          ref.read(roundTableProvider.notifier).reset(); // 局内容.
          ref.read(gameSetProvider.notifier).reset(); // 試合終了フラグ.
          ref.read(reviseCommentProvider.notifier).reset(); // 修正コメント.
          /*----------------------------------------------------------------*/

          ref.read(gameProvider.notifier).progress(); // 試合を進める.

        } else if (resultNext == false) { // キャンセルを押したら.
          gameScore.reset();
        }

      },
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