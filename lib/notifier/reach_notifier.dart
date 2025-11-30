import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReachNotifier extends Notifier<int> {

  @override
  build() => 0;

  void add(int i) {
    state = state + i;
  }

  void reset() {
    state = 0;
  }

}

final reachProvider = NotifierProvider<ReachNotifier, int>(ReachNotifier.new);