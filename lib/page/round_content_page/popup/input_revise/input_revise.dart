import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/popup/input_revise/revise_dialog.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/popup/agari_yane_dialog/agari_yame_dialog.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';

class InputRevise extends ConsumerWidget {
  const InputRevise({
    super.key
  });

  Future<bool?> revisePopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return const ReviseDialog();
      }
    );
  }

  Future<bool?> agariYamePopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return const AgariYameDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void socketInputRound() { // 局内容が入力されたら送る.
      final roomId = ref.read(ruleProvider).id;
      final round = ref.read(roundProvider);
      final reach = ref.read(reachProvider);
      final gameSet = ref.read(gameSetProvider);
      final roundTable = ref.read(roundTableProvider); // List<RoundTable>.
      final comment = ref.read(reviseCommentProvider);
      final player = ref.read(playerProvider); // List<Player>.

      final commentJson = {
        for (final e in comment.entries)
          e.key.toString(): e.value
      };

      final msg = {
        'type': 'input_round',
        'payload': {
          'roomId': roomId, // String?.
          'round': {
            'kyoku': round.$1, // int.
            'honba': round.$2, // int.
          },
          'reach': reach, // int.
          'gameSet': gameSet, // bool.
          'roundTable': roundTable.map((m) => {
            'kyoku': m.kyoku, // String.
            'honba': m.honba, // String.
            'p0': m.p0, // int?.
            'p1': m.p1, // int?.
            'p2': m.p2, // int?.
            'p3': m.p3, // int?.
            'revise': m.revise
          }).toList(),
          'comment': commentJson, // Map<int, String>.
          'score': player.map((m) => {
            'initial': m.initial, // int.
            'zikaze': m.zikaze, // int.
            'score': m.score // int?.
          }).toList()
        }
      };

      ref.read(socketProvider.notifier).send(msg);
    }

    final rule = ref.read(ruleProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await revisePopup(context);   // ポップアップが閉じるまで止まる

        if (result == true) { // ポップアップで完了を押されたら.
        /*---------------------------------------------------------------------------------
          reviseするなら
            ⓵　Playerを新しく入力された値で更新（zikaze と score）
            ⓶　供託と本場を更新
            ⓷　Roundも変更内容によっては変わる可能性がある（親じゃなくて子がアガリだったとか）
            ⓸　round_table_view に渡す RoundTable も変更
        ---------------------------------------------------------------------------------*/
        final gameSet = ref.read(gameSetProvider.notifier);
        gameSet.reset(); // 終局が何4局に変わる可能性があるから.

        final agari = ref.read(agariProvider.notifier);
        final a = ref.read(agariProvider); // reviseポップアップで変更された内容を持ってる.
        ref.read(playerProvider.notifier).revise(); // <void revise() => state = memory;>.
        (int, int) roundMemory = ref.read(roundProvider.notifier).revise(); // <(int, int) revise() => return memory;>
        int reachMemory = ref.read(reachProvider.notifier).revise(); // <int revise() => return memory;>.

        final reach = ref.read(reachProvider.notifier);
        final reachStick = a.reach.where((w) => w == true).length; // reviseしたリーチ棒.
        reach.add(add: reachStick, revise: true); // 状態変更.
        final kyoutaku = reachMemory * 1000;
        final player = ref.read(playerProvider.notifier); // memoryが入ってる.

        if (a.flag == AgariFlag.ron) {
            final honba = roundMemory.$2 * 300;
            player.ron(
              win: a.agari!,
              lose: a.houju!,
              score: a.score!,
              reach: a.reach,
              kyoutaku: kyoutaku,
              honba: honba,
              revise: true
            );
          } else if (a.flag == AgariFlag.tsumo) {
            final honba = roundMemory.$2 * 100;
            player.tsumo(
              win: a.agari!,
              score: a.score!,
              childScore: a.childScore,
              reach: a.reach,
              kyoutaku: kyoutaku,
              honba: honba,
              revise: true
            );
          } else if (a.flag == AgariFlag.ryukyou) {
            player.ryukyoku(
              reach: a.reach,
              tenpai: a.tenpai,
              revise: true
            );
          }

          final host = ref.read(playerProvider)
              .firstWhere((w) => w.zikaze == 0)
              .initial;
          final round = ref.read(roundProvider.notifier);

          if (a.agari == host) { // 親が和了.
            round.honba(revise: true);
            reach.agari();
          } else if (a.agari != null) { // 親以外が和了.
            round.childAgari(revise: true);
            reach.agari();
            player.progress();
          } else { // 流局なら.
            if (a.tenpai[host]) { // 親が聴牌なら.
              round.honba(revise: true);
            } else { // 親がノーテンなら.
              round.hostNoten(revise: true);
              player.progress();
            }
          }

          final roundTable = ref.read(roundTableProvider.notifier);
          final rNext = ref.read(roundProvider);
          final scoreList = ref.read(playerProvider)
              .map((m) => (m.initial, m.score!))
              .toList();
          
          roundTable.revise(
            next: rNext,
            score: scoreList
          );

          final continueHost = (){
            if (a.flag == AgariFlag.ryukyou) {
              return a.tenpai[host];
            } else {
              return host == a.agari;
            }
          }();

          final p = ref.read(playerProvider);
          final hako = p.any((a) => a.score! < 0);

          if (rule.tobi == Tobi.ari && hako) { // 飛んだら.
            // print('飛び');
            player.finish();
            round.finish();
            gameSet.finish();
          }

          if (roundMemory.$1 == 7) { // 南4局.
            // print('南4局');
            final top = scoreList.map((m) => m.$2).reduce(max);

            if (!continueHost) { // 親以外がアガリなら.
              // print('親以外がアガリ');
              if (rule.syanyu == Syanyu.ari) {
                // print('西入あり');
                if (top > 30000) {
                  // print('top > 30000');
                  player.finish();
                  round.finish();
                  gameSet.finish();
                }
              } else if (rule.syanyu == Syanyu.none) {
                // print('西入なし');
                player.finish();
                round.finish();
                gameSet.finish();
              }
            } else if (a.flag != AgariFlag.ryukyou && rule.agariyame == Agariyame.ari) { // ツモかロンでアガリ止め.
              if (!context.mounted) {return;}
              if (rule.syanyu == Syanyu.ari && top <= 30000) {return;}

              final bool? resultYame = await agariYamePopup(context);
              if (resultYame == true) {
                // print('アガリ止め');
                round.finish();
                gameSet.finish();
              }
            }
          } else if (roundMemory.$1 == 11) { // 西4局.
            // print('西4局');
            final top = scoreList.map((m) => m.$2).reduce(max);

            if (!continueHost) {
              // print('親以外がアガリ');
              player.finish();
              round.finish();
              gameSet.finish();
            } else if (a.flag != AgariFlag.ryukyou && rule.agariyame == Agariyame.ari) {
              if (!context.mounted) {return;}
              if (rule.syanyu == Syanyu.ari && top <= 30000) {return;}

              final bool? resultYame = await agariYamePopup(context);
              if (resultYame == true) {
                // print('アガリ止め');
                round.finish();
                gameSet.finish();
              }
            }
          }

          socketInputRound();
          agari.reset();
        }
      },

      child: const Icon(
        CupertinoIcons.right_chevron,
        color: CupertinoColors.activeBlue,
        size: 13,
      )
    );
  }
}