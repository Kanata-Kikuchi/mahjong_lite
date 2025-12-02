import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/model/game_model.dart';

class GameScoreNotifier extends Notifier<List<Game>> {

  List<Game> memory = [
    Game(
      game: '第1試合',
      time: 0,
    )
  ];

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
    required List<(int, int)> score,
    bool? revise = false
  }) {

    if (revise != true) {memory = [...state];}

    final top = score.map((m) => m.$2).reduce(max); // 1位の点数.
    final topInitial = score.firstWhere((w) => w.$2 == top).$1; // 1位のイニシャル.
    final sort = [...score]..sort((a, b) => a.$2.compareTo(b.$2));
    final scoreSort = sort.map((m) => (m.$1, (m.$2 / 1000).round())).toList();
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
      else if (oka == Oka.oka20_25) {base = 25; return scoreSort.where((w) => w.$1 != topInitial).map((m) => 25 - m.$2).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka25_30) {base = 30; return scoreSort.where((w) => w.$1 != topInitial).map((m) => 30 - m.$2).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka30_35) {base = 35; return scoreSort.where((w) => w.$1 != topInitial).map((m) => 35 - m.$2).fold(0, (a, b) => a + b);}
      else {throw Exception('game_score_notifier.dart/okaTop');}
    }();

    scoreSort[0] = (scoreSort[0].$1, scoreSort[0].$2 - umaOutside - base); // 4th.
    scoreSort[1] = (scoreSort[1].$1, scoreSort[1].$2 - umaInside - base); // 3rd. 
    scoreSort[2] = (scoreSort[2].$1, scoreSort[2].$2 + umaInside - base); // 2nd.
    scoreSort[3] = (scoreSort[3].$1, (0 - scoreSort[0].$2 - scoreSort[1].$2 - scoreSort[2].$2) + okaTop); // 1st.

    final scoreSet = scoreSort.map((m) {
      if (m.$2 > 0) {
        return (m.$1, '+${m.$2}pt');
      } else if (m.$2 < 0) {
        return (m.$1, '▲${-m.$2}pt');
      } else {
        return (m.$1, '0pt');
      }
    }).toList();

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

  }

  List<Game> sortInitial() { // イニシャル順の点数リスト.

    if (state.length == 1) {
      return state;
    } else {
      final without = [...state]..removeLast();
      final last = [...state].removeLast();
      List<Game> result = [];

      for (int i = 0; i < without.length; i++) {

        final buf = [
          without[i].score1st,
          without[i].score2nd,
          without[i].score3rd,
          without[i].score4th
        ];

        buf.sort((a, b) => a!.$1.compareTo(b!.$1));

        result = [
          ...result,
          Game(
            game: without[i].game,
            time: without[i].time,
            score1st: buf[0],
            score2nd: buf[1],
            score3rd: buf[2],
            score4th: buf[3]
          )
        ];
      }

      return [
        ...result,
        last
      ];
    }

  }

  void reset() {
    state = memory;
  }

}

final gameScoreProvider = NotifierProvider<GameScoreNotifier, List<Game>>(GameScoreNotifier.new);