import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReachNotifier extends Notifier<int> {

  int memory = 0;

  @override
  build() => 0;

  void debugMode() {
    state = 2;
  }

  void reachSet({
    required int reach
  }) {
    state = reach;
  }

  void add({
    required int add,
    bool? revise = false
  }) {
    if (revise != true) {memory = state;}
    state = state + add;
  }

  void reset() {
    state = 0;
    memory = 0;
  }

  void agari() {
    state = 0;
  }

  int revise() {
    return memory;
  }

}

final reachProvider = NotifierProvider<ReachNotifier, int>(ReachNotifier.new);