import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/model/round_table.dart';

class RoundTableNotifier extends Notifier<List<RoundTable>> {

  /*
  RoundTable(
    kyoku: String,
    honba: String,
    p0: int?,
    p1: int?,
    p2: int?,
    p3: int?,
    revise: bool?
  )
  */

  @override
  build() {
    return [
      RoundTable(
        kyoku: '東1局',
        honba: '0本場'
      )
    ];
  }

  void roundTableSet({
    required List<Map<String, dynamic>> roundTable
  }) {
    List<RoundTable> buf = [];
    
    for (final row in roundTable) {
      buf = [
        ...buf,
        RoundTable(
          kyoku: row['kyoku'],
          honba: row['honba'],
          p0: row['p0'],
          p1: row['p1'],
          p2: row['p2'],
          p3: row['p3']
        )
      ];
    }

    state = buf;
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

  List<List<int>> diffrenceScore({
    required initialScore
  }) {
    if (state.length == 1) {
      return [[0, 0, 0, 0]];
    } else {
      List<List<int>> result = [];
      List<List<int>?> buf = [];

      for (int i = 0; i < state.length; i++) {
        if (state[i].revise == true || (state[i].p1 == null && state[i].p2 == null && state[i].p3 == null)) {
          buf.add(null);
        } else {
          buf.add([state[i].p0!, state[i].p1!, state[i].p2!, state[i].p3!]);
        }
      }

      final List<List<int>?> withoutNull = buf.where((w) => w != null).toList();
      withoutNull.insert(0, [initialScore, initialScore, initialScore, initialScore]);
      List<List<int>> tmp = [];

      for (int i = 0; i < withoutNull.length - 1; i++) {
        List<int> diff = [
          for (int s = 0; s < 4; s++)
            withoutNull[i + 1]![s] - withoutNull[i]![s]
        ];

        tmp.add(diff);
      }

      int c = 0;

      for (int i = 0; i < buf.length; i++) {
        if (buf[i] != null) {
          result.add(tmp[c]);
          c += 1;
        } else {
          result.add([0, 0, 0, 0]);
        }
      }

      return result;
    }
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