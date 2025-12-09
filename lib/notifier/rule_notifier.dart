import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/model/rule_model.dart';

class RuleNotifier extends Notifier<Rule> {

  @override
  Rule build() {
    return Rule( // debug用.
      name: '',
      uma: Uma.none,
      oka: Oka.none25000,
      tobi: Tobi.none,
      syanyu: Syanyu.ari,
      agariyame: Agariyame.ari,
      id: 'abc123'
    );
    // return Rule(
    //   name: null,
    //   uma: null,
    //   oka: null,
    //   tobi: null,
    //   syanyu: null,
    //   agariyame: null,
    //   id: null
    // );
  }

  void name(String name) {
    state = state.copyWith(name: name);
  }

  void uma(Uma? uma) {
    state = state.copyWith(uma: uma);
  }

  void oka(Oka? oka) {
    state = state.copyWith(oka: oka);
  }

  void tobi(Tobi? tobi) {
    state = state.copyWith(tobi: tobi);
  }

  void syanyu(Syanyu? syanyu) {
    state = state.copyWith(syanyu: syanyu);
  }

  void agariyame(Agariyame? agariyame) {
    state = state.copyWith(agariyame: agariyame);
  }

  void id(String? id) {
    state = state.copyWith(id: id);
  }

  void reset() {
    state = Rule(
      name: state.name, // 画面切り替えでもそのまま.
      uma: null,
      oka: null,
      tobi: null,
      syanyu: null,
      agariyame: null,
      id: null
    );
  }

  void debug() {
    print('''
    state = Rule(
      name: ${state.name},
      uma: ${state.uma?.label},
      oka: ${state.oka?.label},
      tobi: ${state.tobi?.label},
      syanyu: ${state.syanyu?.label},
      agariyame: ${state.agariyame?.label},
      id: ${state.id}
    )
    ''');
  }

  void revise() {
    state = Rule(
      name: null,
      uma: null,
      oka: null,
      tobi: null,
      syanyu: null,
      agariyame: null,
      id: null
    );
  }

  bool checkChild() {
    return state.name != null
        && state.id != null;
  }

  bool checkHost() {
    return state.name != null
        && state.uma != null
        && state.oka != null
        && state.tobi != null
        && state.syanyu != null
        && state.agariyame != null;
  }

}

final ruleProvider = NotifierProvider<RuleNotifier, Rule>(RuleNotifier.new);