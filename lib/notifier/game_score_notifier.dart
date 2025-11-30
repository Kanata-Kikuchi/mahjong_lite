import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';

class GameScoreNotifier extends Notifier<List<String>> {

  @override
  build() => [
    '',
    '',
    '',
    ''
  ];

  void set({
    required Uma uma,
    required Oka oka,
    required List<(int, int)> score
  }) {

    final top = score.map((m) => m.$2).reduce(max); // 1位の点数.
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
      else if (oka == Oka.oka20_25) {base = 25; return scoreSort.where((w) => w.$2 != top).map((m) => 25 - m.$2).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka25_30) {base = 30; return scoreSort.where((w) => w.$2 != top).map((m) => 30 - m.$2).fold(0, (a, b) => a + b);}
      else if (oka == Oka.oka30_35) {base = 35; return scoreSort.where((w) => w.$2 != top).map((m) => 35 - m.$2).fold(0, (a, b) => a + b);}
      else {throw Exception('game_score_notifier.dart/okaTop');}
    }();

    scoreSort[0] = (scoreSort[0].$1, scoreSort[0].$2 - umaOutside - base);
    scoreSort[1] = (scoreSort[1].$1, scoreSort[1].$2 - umaInside - base);
    scoreSort[2] = (scoreSort[2].$1, scoreSort[2].$2 + umaInside - base);
    scoreSort[3] = (scoreSort[3].$1, (0 - scoreSort[0].$2 - scoreSort[1].$2 - scoreSort[2].$2) + okaTop);

    final initialSort = [...scoreSort]..sort((a, b) => a.$1.compareTo(b.$1));

    state = initialSort.map((m) {
      if (m.$2 > 0) {
        return '+${m.$2}pt';
      } else if (m.$2 < 0) {
        return '▲${m.$2}pt';
      } else {
        return '0pt';
      }
    }).toList();
  }

}

final gameScoreProvider = NotifierProvider<GameScoreNotifier, List<String>>(GameScoreNotifier.new);