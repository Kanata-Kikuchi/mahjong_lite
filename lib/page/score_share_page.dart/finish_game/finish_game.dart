import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/debug/debug_provider.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/popup/next_game/next_game_dialog.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/popup/result_game/result_game_dialog.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class FinishGame extends ConsumerWidget {
  const FinishGame({
    super.key
  });

  Future<bool?> resultGamePopup(BuildContext context, {
    required List<String> resultNameList,
    required List<String> resultScoreList
  }) { // 誰が何点だったかを表示する.

    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return ResultGameDialog(
          resultNameList: resultNameList,
          resultScoreList: resultScoreList,
        );
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

    void initiativeCheck() {
      final channel = ref.read(socketProvider);

      final roomId = ref.read(ruleProvider).id;
      final gameScore = ref.read(gameScoreProvider);
      final players = ref.read(playerProvider); // この時点ですでに東南西北の順番.

      final msg = {
        'type': 'initiative_check',
        'payload': {
          'roomId': roomId, // String?.
          'gameScore': gameScore.map((m) => {
            'game': m.game, // String.
            'time': m.time, // int.
            'score1st': m.score1st == null // (String, int, String)?.
                ? null
                : {
                    'name': m.score1st!.$1, // String.
                    'initial': m.score1st!.$2, // int.
                    'score': m.score1st!.$3, // String.
                  },
            'score2nd': m.score2nd == null // (String, int, String)?.
                ? null
                : {
                    'name': m.score2nd!.$1, // String.
                    'initial': m.score2nd!.$2, // int.
                    'score': m.score2nd!.$3, // String.
                  },
            'score3rd': m.score3rd == null // (String, int, String)?.
                ? null
                : {
                    'name': m.score3rd!.$1, // String.
                    'initial': m.score3rd!.$2, // int.
                    'score': m.score3rd!.$3, // String.
                  },
            'score4th': m.score4th == null // (String, int, String)?.
                ? null
                : {
                    'name': m.score4th!.$1, // String.
                    'initial': m.score4th!.$2, // int.
                    'score': m.score4th!.$3, // String.
                  },
          }).toList(),
          'players': players.map((m) => {
            'playerId': m.playerId, // String?.
          }).toList()
        }
      };

      channel.sink.add(jsonEncode(msg));
    }

    return GestureDetector( // 終局を押したら.
      behavior: HitTestBehavior.opaque,
      onTap: () async {

        /*-----------ここで試合履歴と集計に使うデータをセットする-------------*/
        final game = ref.watch(gameProvider.notifier);
        final uma = ref.watch(ruleProvider).uma;
        final oka = ref.watch(ruleProvider).oka;
        
        final scoreList = ref.read(playerProvider)
            .map((m) => (m.name!, m.initial, m.score!))
            .toList();

        final gameScore = ref.read(gameScoreProvider.notifier);
        gameScore.set(
          game: game.string(),
          nextGame: game.nextString(),
          uma: uma!,
          oka: oka!,
          score: scoreList,
        );
        /*----------------------------------------------------------------*/

        /* 
          if (resultGame == false) { // キャンセルを押したら.
            gameScore.reset(); // バグ原因。キャンセルを押した瞬間リセット後の値が表示される.
            return;
          }

          後半のポップアップをキャンセルしたときの処理でresetすると、閉じるときに一瞬前の値が表示される。
          原因はResultGameContentでref.watchをしてUI描画しているから。resetでstateが切り替わった瞬間も描画されてしまう。

          解決策としてresultNameList、resultScoreListを用意して、watchしたい内容を渡してあげる。
        
        */
        final gameScorePrv = ref.read(gameScoreProvider);
        final resultNameList = [
          gameScorePrv[gameScorePrv.length - 2].score1st!.$1,
          gameScorePrv[gameScorePrv.length - 2].score2nd!.$1,
          gameScorePrv[gameScorePrv.length - 2].score3rd!.$1,
          gameScorePrv[gameScorePrv.length - 2].score4th!.$1
        ];
        final resultScoreList = [
          gameScorePrv[gameScorePrv.length - 2].score1st!.$3,
          gameScorePrv[gameScorePrv.length - 2].score2nd!.$3,
          gameScorePrv[gameScorePrv.length - 2].score3rd!.$3,
          gameScorePrv[gameScorePrv.length - 2].score4th!.$3
        ];

        final resultGame = await resultGamePopup(
          context,
          resultNameList: resultNameList,
          resultScoreList: resultScoreList
        ); // ゲーム結果Popup.

        if (resultGame == false) { // キャンセルを押したら.
          gameScore.reset();
          return;
        }

        if (!context.mounted) {return;} // awaitの後にcontextを使うと警告が出るから.

        bool? resultNext;

        if (resultGame == true) { // ゲーム結果(result_game_content)のポップアップで完了が押されたら.
          resultNext = await nextGamePopup(context); // Popup.
        }

        if (resultNext == true) { // 親決め(next_game_content)のポップアップで完了が押されたら.

          // /*-------------------------- リセット群 --------------------------*/
          // ref.read(playerProvider.notifier).reset(); // 自風と点数.
          // ref.read(reachProvider.notifier).reset(); // リーチ棒.
          // ref.read(roundProvider.notifier).reset(); // 局と本場.
          // ref.read(roundTableProvider.notifier).reset(); // 局内容.
          // ref.read(gameSetProvider.notifier).reset(); // 試合終了フラグ.
          // ref.read(reviseCommentProvider.notifier).reset(); // 修正コメント.
          // /*----------------------------------------------------------------*/

          // ref.read(gameProvider.notifier).progress(); // 試合を進める.
          initiativeCheck();
          if (ref.read(debugProvider)) {
            /*-------------------------- リセット群 --------------------------*/
            ref.read(playerProvider.notifier).reset(); // 自風と点数.
            ref.read(reachProvider.notifier).reset(); // リーチ棒.
            ref.read(roundProvider.notifier).reset(); // 局と本場.
            ref.read(roundTableProvider.notifier).reset(); // 局内容.
            ref.read(gameSetProvider.notifier).reset(); // 試合終了フラグ.
            ref.read(reviseCommentProvider.notifier).reset(); // 修正コメント.
            /*----------------------------------------------------------------*/
            ref.read(gameProvider.notifier).progress(); // 試合を進める.
          }

          ref.read(playerProvider.notifier).debug();

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
            size: 30,
          )
        ],
      )
    );
  }
}