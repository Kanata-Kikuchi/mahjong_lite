import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/model/game_model.dart';

class GameScoreNotifier extends Notifier<List<Game>> {

  /*
  Game(
    game: String,
    time: int,
    score1st: (String, int, String)?,
    score2nd: (String, int, String)?,
    score3rd: (String, int, String)?,
    score4th: (String, int, String)?,
  )
  */

  List<Game> memory = [
    Game(
      game: '第1試合',
      time: 0,
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

  void fullReset() {
    state = [
      Game(
        game: '第1試合',
        time: 0,
      )
    ];
    memory = [
      Game(
        game: '第1試合',
        time: 0,
      )
    ];
    sum = [];
    scoreMemory = [];
  }

  void debugMode() {
    memory = [
      Game(
        game: '第1試合',
        time: 0,
        score1st: ('debug_D', 3, '+20pt'),
        score2nd: ('debug_A', 0, '+10pt'),
        score3rd: ('debug_C', 2, '▲10pt'),
        score4th: ('debug_B', 1, '▲20pt')
      ),
      Game(
        game: '第2試合',
        time: 0,
      )
    ];
    sum = [
      [('debug_B', -20), ('debug_C', -10), ('debug_A', 10), ('debug_D', 20)],
      [('debug_D', -35), ('debug_B', -15), ('debug_A', 15), ('debug_C', 35)]
    ];
    scoreMemory = [
      [45000, 35000, 15000, 5000],
      [60000, 40000, 10000, -10000]
    ];
    state = [
      Game(
        game: '第1試合',
        time: 0,
        score1st: ('debug_D', 3, '+20pt'),
        score2nd: ('debug_A', 0, '+10pt'),
        score3rd: ('debug_C', 2, '▲10pt'),
        score4th: ('debug_B', 1, '▲20pt')
      ),
      Game(
        game: '第2試合',
        time: 0,
        score1st: ('debug_C', 2, '+35pt'),
        score2nd: ('debug_A', 0, '+15pt'),
        score3rd: ('debug_B', 1, '▲15pt'),
        score4th: ('debug_D', 3, '▲35pt')
      ),
      Game(
        game: '第3試合',
        time: 0,
      )
    ];
  }

  void gameScoreSet({
    required List<dynamic>? sum,
    required List<dynamic>? memory,
    required List<dynamic>? gameScore
  }) {
    if (sum == null || memory == null || gameScore == null) {
      return;
    }

    final decoded = memory
        .map((m) => (m as List).map((i) => i as int).toList())
        .toList();
    scoreMemory = decoded;

    final List<List<(String, int)>> decodedSum = sum
        .whereType<List>()
        .map((game) => game
            .whereType<Map>()
            .map((p) {
              final map = Map<String, dynamic>.from(p);
              return (
                map['name'] as String,
                (map['score'] as num).toInt(),
              );
            })
            .toList())
        .toList();

    this.sum = decodedSum;

    final rows = gameScore
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

    List<Game> buf = [];

    for (final row in rows) {
      if (row['score1st'] == null && row['score2nd'] == null && row['score3rd'] == null && row['score4th'] == null) {
        buf = [
          ...buf,
          Game(
            game: row['game'],
            time: row['time']
          )
        ];
      } else {
        final s1 = Map<String, dynamic>.from(row['score1st'] as Map);
        final s2 = Map<String, dynamic>.from(row['score2nd'] as Map);
        final s3 = Map<String, dynamic>.from(row['score3rd'] as Map);
        final s4 = Map<String, dynamic>.from(row['score4th'] as Map);

        buf = [
          ...buf,
          Game(
            game: row['game'],
            time: row['time'],
            score1st: (s1['name'], s1['initial'], s1['score']),
            score2nd: (s2['name'], s2['initial'], s2['score']),
            score3rd: (s3['name'], s3['initial'], s3['score']),
            score4th: (s4['name'], s4['initial'], s4['score']),
          )
        ];
      }
    }

    state = buf;
  }

  (List<List<int>>, List<List<(String, int)>>) set({
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
    final sort = [...score]..sort((a, b) {
      final cmp = a.$3.compareTo(b.$3);
      if (cmp != 0) {
        return cmp;
      } else { // 同点なら起家順に.
        return b.$2.compareTo(a.$2);
      }
    }); // 点数でソート.
    final scoreSort = sort.map((m) => (m.$1, m.$2, (m.$3 / 1000).round())).toList(); // ソートした点数を1000で割って四捨五入.
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

    return (scoreMemory, sum);

    // print('set() / state.length: ${state.length}');

  }

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
    // print('score() / state.length: ${state.length}');
    return scoreMemory;
  }

  List<(String, String)> sumScore() {
    // print('sumScore() / state.length: ${state.length}');

    List<(String, String)> result = [];
    List<(String, int)> sortScore = [];

    List<(String, int)> buf = [];
    for (final game in sum) {
      buf = [...buf, ...game];
    }

    final nameSet = buf.map((m) => m.$1).toSet();
    for (final name in nameSet) {
      final sum = buf.where((w) => w.$1 == name).map((m) => m.$2).fold(0, (a, b) => a + b);
      sortScore = [...sortScore, (name, sum)];
    }

    sortScore.sort((a,b) => b.$2.compareTo(a.$2));

    result = sortScore.map((m) {
      String total;
      if (m.$2 > 0) {
        total = '+${m.$2}pt';
      } else if (m.$2 < 0) {
        total = '▲${-m.$2}pt';
      } else {
        total = '0pt';
      }
      return (m.$1, total);
    }).toList();

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