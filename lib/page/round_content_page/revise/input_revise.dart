import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/revise/revise_dialog.dart';
import 'package:mahjong_lite/debug/debug_print_agari.dart';

class InputRevise extends ConsumerWidget {
  const InputRevise({
    super.key
  });

  Future<bool?> revisePopup(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return ReviseDialog();
      }
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await revisePopup(context);   // ← ポップアップが閉じるまで止まる

        if (result == true) { // ポップアップで完了を押されたら.
          final round = ref.read(roundProvider.notifier);
          final player = ref.read(playerProvider.notifier);
          final reach = ref.read(reachProvider.notifier);
          final roundTable = ref.read(roundTableProvider.notifier); // 局内容の表に渡す状態.

          final a = ref.read(agariProvider);
          final host = ref.read(playerProvider) // この局の親.
              .firstWhere((w) => w.zikaze == 0)
              .initial;

          final reachStick = a.reach.where((w) => w == true).length; // この局のリーチ棒.
          reach.add(reachStick); // 状態変更.
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
            reach.reset();
          } else if (a.agari != null) { // 親以外が和了.
            round.kyoku();
            round.reset();
            reach.reset();
            player.progress();
          } else { // 流局なら.
            if (a.tenpai[host]) { // 親が聴牌なら.
              round.honba();
            } else { // 親がノーテンなら.
              round.kyoku();
              round.honba();
              player.progress();
            }
          }

          final rNext = ref.read(roundProvider); // resetとかした後に.
          final scoreList = ref.read(playerProvider)
              .map((m) => (m.initial, m.score))
              .toList();
              
          roundTable.add(
            round: rNow,
            next: rNext,
            score: scoreList
          );

          // print('r: $rNow, ne: $rNext');
          // final pnz = ref.read(playerProvider).map((m) => (m.name, m.zikaze.toString())).toList();
          // print('${pnz[0].$1}: ${pnz[0].$2}, ${pnz[1].$1}: ${pnz[1].$2}, ${pnz[2].$1}: ${pnz[2].$2}, ${pnz[3].$1}: ${pnz[3].$2}');
          debugPrintAgari(ref.read(agariProvider));
        }
      },

      child: Icon(
        CupertinoIcons.right_chevron,
        color: CupertinoColors.activeBlue,
        size: 17,
      )
    );
  }
}