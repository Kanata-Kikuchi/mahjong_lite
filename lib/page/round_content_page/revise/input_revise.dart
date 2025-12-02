import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/model/player_model.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/revise/revise_dialog.dart';

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

    final syanyu = ref.watch(ruleProvider).syanyu;

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

        // ⓵ : PlayerNotifier 内で memory として最終変更前の値を保持  <void revise() => state = memory;>.

        // List<Player> memory = [
        //   Player(name: 'Aさん', initial: 0, zikaze: 0, score: 25000),
        //   Player(name: 'Bさん', initial: 1, zikaze: 1, score: 25000),
        //   Player(name: 'Cさん', initial: 2, zikaze: 2, score: 25000),
        //   Player(name: 'Dさん', initial: 3, zikaze: 3, score: 25000)
        // ];

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
            reach.reset();
          } else if (a.agari != null) { // 親以外が和了.
            round.childAgari(revise: true);
            reach.reset();
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
              .map((m) => (m.initial, m.score))
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

          final gameSet = ref.read(gameSetProvider.notifier);

          if (roundMemory.$1 == 7 && !continueHost) { // 南4局.
            if (syanyu == Syanyu.ari) {
              final top = scoreList.map((m) => m.$2).reduce(max);
              if (top > 30000) {
                gameSet.finish();
              }
            } else if (syanyu == Syanyu.none) {
              gameSet.finish();
            } else {
              throw Exception('imput_round.dart/syanyu');
            }
          } else if (roundMemory.$1 == 11 && !continueHost) { // 西4局.
            gameSet.finish();
          }

        

              


          // // print('r: $rNow, ne: $rNext');
          // // final pnz = ref.read(playerProvider).map((m) => (m.name, m.zikaze.toString())).toList();
          // // print('${pnz[0].$1}: ${pnz[0].$2}, ${pnz[1].$1}: ${pnz[1].$2}, ${pnz[2].$1}: ${pnz[2].$2}, ${pnz[3].$1}: ${pnz[3].$2}');
          // debugPrintAgari(ref.read(agariProvider));
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