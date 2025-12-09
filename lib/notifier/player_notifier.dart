import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/model/player_model.dart';

class PlayerNotifier extends Notifier<List<Player>> {

  /*
  Player(
    playerId: String?,
    name: String?,
    initial: int,
    zikaze: int,
    score: int?
  )
  */

  List<Player> memory = [
    Player(playerId: null, name: null, initial: 0, zikaze: 0, score: null),
    Player(playerId: null, name: null, initial: 1, zikaze: 1, score: null),
    Player(playerId: null, name: null, initial: 2, zikaze: 2, score: null),
    Player(playerId: null, name: null, initial: 3, zikaze: 3, score: null)
  ];

  List<String> initialNameList = [ // debug用、本来は初期値null.
    'kanata',
    'A',
    'B',
    'C'
  ];

  // int? initialScore;
  int? initialScore = 25000; // debug用.

  @override
  List<Player> build() {
    // return [
    //   Player(playerId: null, name: null, initial: 0, zikaze: 0, score: null),
    //   Player(playerId: null, name: null, initial: 1, zikaze: 1, score: null),
    //   Player(playerId: null, name: null, initial: 2, zikaze: 2, score: null),
    //   Player(playerId: null, name: null, initial: 3, zikaze: 3, score: null)
    // ];
    return [ // debug用.
      Player(playerId: null, name: 'kanata', initial: 0, zikaze: 0, score: 25000),
      Player(playerId: null, name: 'A', initial: 1, zikaze: 1, score: 25000),
      Player(playerId: null, name: 'B', initial: 2, zikaze: 2, score: 25000),
      Player(playerId: null, name: 'C', initial: 3, zikaze: 3, score: 25000)
    ];
  }

  void playerSet({
    required List<Map<String, dynamic>> player
  }) {
    for (final row in player) {
      state = [
        for (final p in state)
          p.initial == row['initial']
            ? p.copyWith(zikaze: row['zikaze'], score: row['score'])
            : p
      ];
    }
  }

  void playerIdAndNameSet({
    required String playerId,
    required int initial,
    required String name
  }) {
    state = [
      for (final p in state)
        p.initial == initial
          ? p.copyWith(playerId: playerId, name: name)
          : p
    ];

    initialNameList[initial] = name;
  }

  void scoreSet({
    required int score
  }) {
    initialScore = score;
    state = [
      ...state.map((m) => m.copyWith(score: score))
    ];
  }

  void changeTonNan() {
    state = [
      state[0].copyWith(name: state[1].name),
      state[1].copyWith(name: state[0].name),
      state[2],
      state[3]
    ];
  }

  void changeNanSya() {
    state = [
      state[0],
      state[1].copyWith(name: state[2].name),
      state[2].copyWith(name: state[1].name),
      state[3]
    ];
  }

  void changeSyaPei() {
    state = [
      state[0],
      state[1],
      state[2].copyWith(name: state[3].name),
      state[3].copyWith(name: state[2].name)
    ];
  }

  void progress() {
    state = [
      for (final player in state) 
        player.copyWith(zikaze: (player.zikaze - 1) % 4)
    ];
  }

  void finish() {
    state = [
      for (final player in state) 
        player.copyWith(zikaze: (player.zikaze + 1) % 4)
    ];
  }

  void ron({
    required int win,
    required int lose,
    required int score,
    required List<bool> reach,
    required int kyoutaku,
    required int honba,
    bool? revise = false
  }) {

    if (revise != true) {memory = [...state];}

    state = [ // リーチ棒の減算.
      for (final player in state) 
        if (reach[player.initial])
          player.copyWith(score: player.score! - 1000)
        else
          player
    ];

    state = [
      for (final player in state)
        if (player.initial == win) // 和了なら.
          player.copyWith(score: player.score! + (score + kyoutaku + honba))
        else if (player.initial == lose) // 放銃なら.
          player.copyWith(score: player.score! - (score + honba))
        else
          player
    ];

  }

  void tsumo({
    required int win,
    required int score,
    required int? childScore,
    required List<bool> reach,
    required int kyoutaku,
    required int honba,
    bool? revise = false
  }) {

    if (revise != true) {memory = [...state];}

    final host = state.firstWhere((w) => w.zikaze == 0).initial;

    state = [ // リーチ棒の減算.
      for (final player in state) 
        if (reach[player.initial])
          player.copyWith(score: player.score! - 1000)
        else
          player
    ];

    if (win == host) { // 親なら.

      state = [
        for (final player in state)
          if (player.initial == win) // 和了.
            player.copyWith(score: player.score! + (score * 3 + kyoutaku + honba * 3))
          else
            player.copyWith(score: player.score! - (score + honba))
      ];

    } else { // 子なら.

      state = [
        for (final player in state)
          if (player.initial == win) // 和了.
            player.copyWith(score: player.score! + (score + childScore! * 2 + kyoutaku + honba * 3))
          else if (player.zikaze == 0) // 親.
            player.copyWith(score: player.score! - (score + honba))
          else // 子.
            player.copyWith(score: player.score! - (childScore! + honba))
      ];

    }

  }

  void ryukyoku({
    required List<bool> reach,
    required List<bool> tenpai,
    bool? revise = false
  }) {

    if (revise != true) {memory = [...state];}

    int tenpaiAdd;
    int tenpaiSub;
    final tenpaiLength = tenpai.where((w) => w == true).length;

    if (tenpaiLength == 1) {
      tenpaiAdd = 3000;
      tenpaiSub = 1000;
    } else if (tenpaiLength == 2) {
      tenpaiAdd = 1500;
      tenpaiSub = 1500;
    } else if (tenpaiLength == 3) {
      tenpaiAdd = 1000;
      tenpaiSub = 3000;
    } else {
      tenpaiAdd = 0;
      tenpaiSub = 0;
    }

    state = [ // リーチ棒の減算.
      for (final player in state) 
        if (reach[player.initial])
          player.copyWith(score: player.score! - 1000)
        else
          player
    ];

    state = [
      for (final player in state) 
        if (tenpai[player.initial])
          player.copyWith(score: player.score! + tenpaiAdd)
        else
          player.copyWith(score: player.score! - tenpaiSub)
    ];
  }

  void reset() {
    state = [
      state[0].copyWith(zikaze: 0, score: initialScore),
      state[1].copyWith(zikaze: 1, score: initialScore),
      state[2].copyWith(zikaze: 2, score: initialScore),
      state[3].copyWith(zikaze: 3, score: initialScore)
    ];

    memory = [
      Player(playerId: null, name: null, initial: 0, zikaze: 0, score: null),
      Player(playerId: null, name: null, initial: 1, zikaze: 1, score: null),
      Player(playerId: null, name: null, initial: 2, zikaze: 2, score: null),
      Player(playerId: null, name: null, initial: 3, zikaze: 3, score: null)
    ];
  }

  List<String> initialName() {
    return initialNameList;
  }

  int initScore() {
    return initialScore!;
  }

  void revise() {
    state = memory;
  }

  void debug() {
    print('''
    state = [
      Player(playerId: ${state[0].playerId}, name: ${state[0].name}, initial: ${state[0].initial}, zikaze: ${state[0].zikaze}, score: ${state[0].score}),
      Player(playerId: ${state[1].playerId}, name: ${state[1].name}, initial: ${state[1].initial}, zikaze: ${state[1].zikaze}, score: ${state[1].score}),
      Player(playerId: ${state[2].playerId}, name: ${state[2].name}, initial: ${state[2].initial}, zikaze: ${state[2].zikaze}, score: ${state[2].score}),
      Player(playerId: ${state[3].playerId}, name: ${state[3].name}, initial: ${state[3].initial}, zikaze: ${state[3].zikaze}, score: ${state[3].score})
    ];
''');
  }

}

final playerProvider = NotifierProvider<PlayerNotifier, List<Player>>(PlayerNotifier.new);