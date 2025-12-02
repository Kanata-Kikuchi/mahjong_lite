import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/model/round_table.dart';

class RoundTableNotifier extends Notifier<List<RoundTable>> {

  @override
  build() {
    return [
      RoundTable(
        kyoku: '東1局',
        honba: '0本場'
      )
    ];
  }

  void add({
    required (int, int) round,
    required (int, int) next,
    required List<(int, int)> score
  }) {

    final kyokuString = '${kyokuMap[round.$1]}${(round.$1 % 4) + 1}局';
    final honbaString = ' ${round.$2}本場';

    final kyokuNextString = '${kyokuMap[next.$1]}${(next.$1 % 4) + 1}局';
    final honbaNextString = ' ${next.$2}本場';

    state.removeLast();

    state = [
      ...state,
      RoundTable(
        kyoku: kyokuString,
        honba: honbaString,
        p0: score[0].$2,
        p1: score[1].$2,
        p2: score[2].$2,
        p3: score[3].$2
      ),
      RoundTable(
        kyoku: kyokuNextString,
        honba: honbaNextString
      )
    ];
  }

  void revise({
    required (int, int) next,
    required List<(int, int)> score
  }) {

    final kyokuNextString = '${kyokuMap[next.$1]}${(next.$1 % 4) + 1}局';
    final honbaNextString = ' ${next.$2}本場';

    state.removeLast();
    final revise = state.removeLast();

    state = [
      ...state,
      RoundTable(
        kyoku: revise.kyoku,
        honba: revise.honba,
        p0: revise.p0,
        p1: revise.p1,
        p2: revise.p2,
        p3: revise.p3,
        revise: true // 修正済みをマーク.
      ),
      RoundTable(
        kyoku: revise.kyoku,
        honba: revise.honba,
        p0: score[0].$2,
        p1: score[1].$2,
        p2: score[2].$2,
        p3: score[3].$2
      ),
      RoundTable(
        kyoku: kyokuNextString,
        honba: honbaNextString
      )
    ];

  }

  int reviseIndex() { // ポップアップの中で使う.
    return state.length - 2;
  }

  void reset() {
    state = [
      RoundTable(
        kyoku: '東1局',
        honba: '0本場'
      )
    ];
  }

}

final roundTableProvider = NotifierProvider<RoundTableNotifier, List<RoundTable>>(RoundTableNotifier.new);