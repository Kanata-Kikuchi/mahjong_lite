import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/popup/agari_dialog/agari_dialog.dart';
import 'package:mahjong_lite/page/score_share_page.dart/input_round/popup/agari_yane_dialog/agari_yame_dialog.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class InputRound extends ConsumerWidget {
  const InputRound({
    required this.socketInputSend,
    super.key
  });

  final void Function() socketInputSend;

  Future<bool?> agariPopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return const AgariDialog();
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

    final rule = ref.read(ruleProvider);
    final round = ref.read(roundProvider);
    final gameSet = ref.read(gameSetProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await agariPopup(context);   // ← ポップアップが閉じるまで止まる

        if (result == true) { // ポップアップで完了を押されたら.
          final agari = ref.read(agariProvider.notifier);
          final round = ref.read(roundProvider.notifier);
          final player = ref.read(playerProvider.notifier);
          final reach = ref.read(reachProvider.notifier);
          final roundTable = ref.read(roundTableProvider.notifier); // 局内容の表に渡す状態.

          final a = ref.read(agariProvider);
          final host = ref.read(playerProvider) // この局の親.
              .firstWhere((w) => w.zikaze == 0)
              .initial;

          final reachStick = a.reach.where((w) => w == true).length; // この局のリーチ棒.
          reach.add(add: reachStick); // 状態変更.
          final kyoutaku = ref.read(reachProvider) * 1000; // この局までのリーチ棒の合計.


          if (a.flag == AgariFlag.ron) {
            final honba = ref.read(roundProvider).$2 * 300;
            player.ron( // 点数計算.
              win: a.agari!,
              lose: a.houju!,
              score: a.score!,
              reach: a.reach,
              kyoutaku: kyoutaku,
              honba: honba
            );
          } else if (a.flag == AgariFlag.tsumo) {
            final honba = ref.read(roundProvider).$2 * 100;
            player.tsumo( // 点数計算.
              win: a.agari!,
              score: a.score!,
              childScore: a.childScore,
              reach: a.reach,
              kyoutaku: kyoutaku,
              honba: honba
            );
          } else if (a.flag == AgariFlag.ryukyou) {
            player.ryukyoku( // 点数計算.
              reach: a.reach,
              tenpai: a.tenpai
            );
          }

          final rNow = ref.read(roundProvider); // resetとかする前に.

          if (a.agari == host) { // 親が和了.
            round.honba();
            reach.agari();
          } else if (a.agari != null) { // 親以外が和了.
            round.childAgari();
            reach.agari();
            player.progress();
          } else { // 流局なら.
            if (a.tenpai[host]) { // 親が聴牌なら.
              round.honba();
            } else { // 親がノーテンなら.
              round.hostNoten();
              player.progress();
            }
          }

          final rNext = ref.read(roundProvider); // resetとかした後に.
          final scoreList = ref.read(playerProvider)
              .map((m) => (m.initial, m.score!))
              .toList();
              
          roundTable.add(
            round: rNow,
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

          if (rNow.$1 == 7) { // 南4局.
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
          } else if (rNow.$1 == 11) { // 西4局.
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

          socketInputSend(); // 親からもらった送信処理.
          agari.reset();
        }
      },

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text( // ラウンド表記.
            '${kyokuMap[round.$1]} ${(round.$1) % 4 + 1} 局',
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