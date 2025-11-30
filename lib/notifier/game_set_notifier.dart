import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetNotifier extends Notifier<bool> {

  @override
  build() => false;

  void finish() {
    state = true;
  }

  void reset() {
    state = false;
  }

}

final gameSetProvider = NotifierProvider<GameSetNotifier, bool>(GameSetNotifier.new);