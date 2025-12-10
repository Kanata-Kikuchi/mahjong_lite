import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundNotifier extends Notifier<(int, int)> {

  (int, int) memory = (0, 0);

  @override
  build() => (0, 0);

  void debugMode() {
    state = (2, 1);
  }

  void finish() {
    state = memory;
  }

  void roundSet({
    required int kyoku,
    required int honba
  }) {
    state = (kyoku, honba);
  }

  void honba({ // 親が聴牌 or 親がアガリ.
    bool? revise = false
  }) {
    if (revise != true) {
      memory = state;
      state = (state.$1, state.$2 + 1);
    } else {
      state = (memory.$1, memory.$2 + 1);
    }
  }

  void hostNoten({ // 親がノーテン.
    bool? revise = false
  }) {
    if (revise != true) {
      memory = state;
      state = (state.$1 + 1, state.$2 + 1);
    } else {
      state = (memory.$1 + 1, memory.$2 + 1);
    }
  }

  void childAgari({ // 子がアガリ.
    bool? revise = false
  }) {
    if (revise != true) {
      memory = state;
      state = (state.$1 + 1, 0);
    } else {
      state = (memory.$1 + 1, 0);
    }
  }

  (int, int) revise() {
    return memory;
  }

  void reset() {
    state = (0, 0);
    memory = (0, 0);
  }

}

final roundProvider = NotifierProvider<RoundNotifier, (int, int)>(RoundNotifier.new);