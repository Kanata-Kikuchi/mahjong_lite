import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundNotifier extends Notifier<(int, int)> {

  @override
  build() => (0, 0);

  void kyoku() {
    state = (state.$1 + 1, state.$2);
  }

  void honba() {
    state = (state.$1, state.$2 + 1);
  }

  void reset() {
    state = (state.$1, 0);
  }

}

final roundProvider = NotifierProvider<RoundNotifier, (int, int)>(RoundNotifier.new);