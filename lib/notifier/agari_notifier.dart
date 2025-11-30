import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/model/agari_model.dart';

class AgariNotifier extends Notifier<Agari> {

  @override
  Agari build() {
    return Agari(
      flag: AgariFlag.ron,
      reach: [false, false, false, false],
      tenpai: [false, false, false, false],
      houju: null,
      agari: null,
      score: null,
      childScore: null,
      revise: null
    );
  }

  void flag(AgariFlag flag) {
    state = state.copyWith(flag: flag);
  }

  void reach(List<bool> list) {
    state = state.copyWith(reach: list);
  }

  void tenpai(List<bool> list) {
    state = state.copyWith(tenpai:  list);
  }

  void houju(int? list) {
    state = state.copyWith(houju: list);
  }

  void agari(int? i) {
    state = state.copyWith(agari: i);
  }

  void score(int? i) {
    state = state.copyWith(score: i);
  }

  void childScore(int? i) {
    state = state.copyWith(childScore: i);
  }

  void reset() {
    state = Agari(
      flag: null,
      reach: [false, false, false, false],
      tenpai: [false, false, false, false],
      houju: null,
      agari: null,
      score: null,
      childScore: null,
      revise: null
    );
  }

  bool checkRon() {
    return state.houju != null
        && state.agari != null
        && state.score != null;
  }

  bool checkTsumo() {
    return state.agari != null
        && state.score != null;
  }

}

final agariProvider = NotifierProvider<AgariNotifier, Agari>(AgariNotifier.new);