import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/model/game_model.dart';
import 'package:mahjong_lite/model/player_model.dart';

class GameScoreNotifier extends Notifier<List<Game>> {

  List<Game> memory = [
    Game(
      game: '第1試合',
      time: 0,
      // score1st (name, initial, score.toString)
    )
  ];

  List<List<(String, int)>> sum = []; // (name, score).

  List<List<int>> scoreMemory = [];

  @override
  build() => [
    Game(
      game: '第1試合',
      time: 0,
    )
  ];

  void set({
    required String game,
    required String nextGame,
    required Uma uma,
    required Oka oka,
    required List<(String, int, int)> score
  }) {

    memory = [...state];

    final s = score.map((m) => m.$3).toList();
    scoreMemory =[...scoreMemory, [...s..sort((a, b) => a.compareTo(b))]];

    final top = score.map((m) => m.$3).reduce(max); // 1位の点数.
    final topInitial = score.firstWhere((w) => w.$3 == top).$2; // 1位のイニシャル.
    final sort = [...score]..sort((a, b) => a.$3.compareTo(b.$3));
    final scoreSort = sort.map((m) => (m.$1, m.$2, (m.$3 / 1000).round())).toList();
    late int base;

    final umaOutside = (){
      if (uma == Uma.none) {return 0;}
      else if (uma == Uma.uma5_10) {return 10;}
      else if (uma == Uma.uma10_20) {return 20;}
      else if (uma == Uma.uma10_30) {return 30;}
      else if (uma == Uma.uma20_30) {return 30;}
      else {throw Exception('game_score_notifier.dart/umaOutside');}
    }();
    
    final umaInside = (){
      if (uma == Uma.none) {return 0;}
      else if (uma == Uma.uma5_10) {return 5;}
      else if (uma == Uma.uma10_20) {return 10;}
      else if (uma == Uma.uma10_30) {return 10;}
      else if (uma == Uma.uma20_30) {return 20;}
      else {throw Exception('game_score_notifier.dart/Inside');}
    }();

    final okaTop = (){
      if (oka == Oka.none20000) {base = 20; return 0;}
      else if (oka == Oka.none25000) {base = 25; return 0;}
      else if (oka == Oka.none30000) {base = 30; return 0;}
      else if (oka == Oka.oka20_25) {base = 25; return scoreSort.where((w) => w.$2 != topInitial).map((m) => 25 - m.$3).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka25_30) {base = 30; return scoreSort.where((w) => w.$2 != topInitial).map((m) => 30 - m.$3).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka30_35) {base = 35; return scoreSort.where((w) => w.$2 != topInitial).map((m) => 35 - m.$3).fold(0, (a, b) => a + b);}
      else {throw Exception('game_score_notifier.dart/okaTop');}
    }();

    scoreSort[0] = (scoreSort[0].$1, scoreSort[0].$2, scoreSort[0].$3 - umaOutside - base); // 4th.
    scoreSort[1] = (scoreSort[1].$1, scoreSort[1].$2, scoreSort[1].$3 - umaInside - base); // 3rd. 
    scoreSort[2] = (scoreSort[2].$1, scoreSort[2].$2, scoreSort[2].$3 + umaInside - base); // 2nd.
    scoreSort[3] = (scoreSort[3].$1, scoreSort[3].$2, (0 - scoreSort[0].$3 - scoreSort[1].$3 - scoreSort[2].$3) + okaTop); // 1st.

    List<(String, int)> buf = [];

    final scoreSet = scoreSort.map((m) {
      buf = [...buf, (m.$1, m.$3)];
      if (m.$3 > 0) {
        return (m.$1, m.$2, '+${m.$3}pt');
      } else if (m.$3 < 0) {
        return (m.$1, m.$2, '▲${-m.$3}pt');
      } else {
        return (m.$1, m.$2, '0pt');
      }
    }).toList();

    sum = [...sum, buf]; // 他で使う.

    final without = [...state]..removeLast();

    state = [
      ...without,
      Game(
        game: game,
        time: 0,
        score1st: scoreSet[3],
        score2nd: scoreSet[2],
        score3rd: scoreSet[1],
        score4th: scoreSet[0]
      ),
      Game(
        game: nextGame,
        time: 0
      )
    ];

    // print('set() / state.length: ${state.length}');

  }

  // List<Game> sortInitial() { // イニシャル順の点数リスト.

  //   if (state.length == 1) {
  //     // print('sortInitial()/if / state.length: ${state.length}');
  //     return state;
  //   } else {
  //     final without = [...state]..removeLast();
  //     final last = [...state].removeLast();
  //     List<Game> result = [];

  //     for (int i = 0; i < without.length; i++) {

  //       final buf = [
  //         without[i].score1st,
  //         without[i].score2nd,
  //         without[i].score3rd,
  //         without[i].score4th
  //       ];

  //       buf.sort((a, b) => a!.$2.compareTo(b!.$2));

  //       result = [
  //         ...result,
  //         Game(
  //           game: without[i].game,
  //           time: without[i].time,
  //           score1st: buf[0],
  //           score2nd: buf[1],
  //           score3rd: buf[2],
  //           score4th: buf[3]
  //         )
  //       ];
  //     }

  //     // print('sortInitial()/else / state.length: ${state.length}');

  //     return [
  //       ...result,
  //       last
  //     ];
  //   }

  // }

  List<Game> sortName({ // total_table_view用.
    required List<String> initialName
  }) {

    // print('sortName() / state.length: ${state.length}');

    if (state.length == 1) {
      // print('sortName()/if / state.length: ${state.length}');
      return state;
    } else {
      final without = [...state]..removeLast();
      final last = [...state].removeLast();
      List<(String, int, String)> bufScore = [];
      List<List<(String, int, String)>> bufName = [];
      List<Game> result = [];

      for (final game in without) {
        bufScore = [
          game.score1st!,
          game.score2nd!,
          game.score3rd!,
          game.score4th!
        ];

        bufName = [
          ...bufName,
          [
            bufScore.firstWhere((w) => w.$1 == initialName[0]),
            bufScore.firstWhere((w) => w.$1 == initialName[1]),
            bufScore.firstWhere((w) => w.$1 == initialName[2]),
            bufScore.firstWhere((w) => w.$1 == initialName[3])
          ]
        ];
      }

      for (int i = 0; i < bufName.length; i++) {
        result = [
          ...result,
          Game(
            game: without[i].game,
            time: without[i].time,
            score1st: bufName[i][0],
            score2nd: bufName[i][1],
            score3rd: bufName[i][2],
            score4th: bufName[i][3]
          )
        ];
      }

      // print('sortName()/else / state.length: ${state.length}');

      return [
        ...result,
        last
      ];

    }

  }

  List<List<int>> score() {
    print('score() / state.length: ${state.length}');
    return scoreMemory;
  }

  List<(String, String)> sumScore() {
    // print('sumScore() / state.length: ${state.length}');

    List<(String, String)> result = [];

    List<(String, int)> buf = [];
    for (final game in sum) {
      buf = [...buf, ...game];
    }

    final nameSet = buf.map((m) => m.$1).toSet();
    for (final name in nameSet) {
      final sum = buf.where((w) => w.$1 == name).map((m) => m.$2).fold(0, (a, b) => a + b);

      String total;
      if (sum > 0) {
        total = '+${sum}pt';
      } else if (sum < 0) {
        total = '▲${-sum}pt';
      } else {
        total = '0pt';
      }
      
      result = [...result, (name, total)];
    }

    return result;

  }

  void reset() {
    // print('reset() / state.length: ${state.length}');
    state = memory;
    scoreMemory = [...scoreMemory]..removeLast();
    sum = [...sum]..removeLast();
  }

}

final gameScoreProvider = NotifierProvider<GameScoreNotifier, List<Game>>(GameScoreNotifier.new);