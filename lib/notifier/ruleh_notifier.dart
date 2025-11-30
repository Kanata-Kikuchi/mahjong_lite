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
    return Rule(
      name: '',
      uma: Uma.none,
      oka: Oka.none25000,
      tobi: Tobi.none,
      syanyu: Syanyu.none,
      agariyame: Agariyame.ari
    );
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

}

final ruleProvider = NotifierProvider<RuleNotifier, Rule>(RuleNotifier.new);