import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameNotifier extends Notifier<int> {

  @override
  build() => 1;

  void debugMode() {
    state = 3;
  }

  void progress() {
    state = state + 1;
  }

  void gameSet({
    required int game
  }) {
    state = game;
  }

  String string() {
    return '第$state試合';
  }

  String nextString() {
    return '第${state + 1}試合';
  }

}

final gameProvider = NotifierProvider<GameNotifier, int>(GameNotifier.new);