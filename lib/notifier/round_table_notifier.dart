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
    final honbaString = '  ${round.$2}本場';

    final kyokuNextString = '${kyokuMap[next.$1]}${(next.$1 % 4) + 1}局';
    final honbaNextString = '  ${next.$2}本場';

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

}

final roundTableProvider = NotifierProvider<RoundTableNotifier, List<RoundTable>>(RoundTableNotifier.new);