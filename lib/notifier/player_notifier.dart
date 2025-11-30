import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/model/player_model.dart';

class PlayerNotifier extends Notifier<List<Player>> {

  @override
  List<Player> build() {
    return [
      Player(name: 'Aさん', initial: 0, zikaze: 0, score: 25000),
      Player(name: 'Bさん', initial: 1, zikaze: 1, score: 25000),
      Player(name: 'Cさん', initial: 2, zikaze: 2, score: 25000),
      Player(name: 'Dさん', initial: 3, zikaze: 3, score: 25000)
    ];
  }

  void progress() {
    state = [
      for (final player in state) 
        player.copyWith(zikaze: (player.zikaze - 1) % 4)
    ];
  }

  void ron({
    required int win,
    required int lose,
    required int score,
    required List<bool> reach,
    required int kyoutaku,
    required int honba
  }) {

    state = [ // リーチ棒の減算.
      for (final player in state) 
        if (reach[player.initial])
          player.copyWith(score: player.score - 1000)
        else
          player
    ];

    state = [
      for (final player in state)
        if (player.initial == win) // 和了なら.
          player.copyWith(score: player.score + (score + kyoutaku + honba))
        else if (player.initial == lose) // 放銃なら.
          player.copyWith(score: player.score - (score + honba))
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
    required int honba
  }) {

    final host = state.firstWhere((w) => w.zikaze == 0).initial;

    state = [ // リーチ棒の減算.
      for (final player in state) 
        if (reach[player.initial])
          player.copyWith(score: player.score - 1000)
        else
          player
    ];

    if (win == host) { // 親なら.

      state = [
        for (final player in state)
          if (player.initial == win) // 和了.
            player.copyWith(score: player.score + (score * 3 + kyoutaku + honba * 3))
          else
            player.copyWith(score: player.score - (score + honba))
      ];

    } else { // 子なら.

      state = [
        for (final player in state)
          if (player.initial == win) // 和了.
            player.copyWith(score: player.score + (score + childScore! * 2 + kyoutaku + honba * 3))
          else if (player.zikaze == 0) // 親.
            player.copyWith(score: player.score - (score + honba))
          else // 子.
            player.copyWith(score: player.score - (childScore! + honba))
      ];

    }

  }

  void ryukyoku({
    required List<bool> reach,
    required List<bool> tenpai
  }) {

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
          player.copyWith(score: player.score - 1000)
        else
          player
    ];

    state = [
      for (final player in state) 
        if (tenpai[player.initial])
          player.copyWith(score: player.score + tenpaiAdd)
        else
          player.copyWith(score: player.score - tenpaiSub)
    ];
  }

}

final playerProvider = NotifierProvider<PlayerNotifier, List<Player>>(PlayerNotifier.new);