import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameNotifier extends Notifier<int> {

  @override
  build() => 1;

  void progress() {
    state = state + 1;
  }

}

final gameProvider = NotifierProvider<GameNotifier, int>(GameNotifier.new);