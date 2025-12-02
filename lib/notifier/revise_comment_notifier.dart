import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviseCommentNotifier extends Notifier<Map<int, String>> {

  @override
  Map<int, String> build() => {};

  void set({
    required int index,
    required String text
  }) {

    state = {
      ...state,
      index: text
    };

  }

  void reset() {
    state = {};
  }

}

final reviseCommentProvider = NotifierProvider<ReviseCommentNotifier, Map<int, String>>(ReviseCommentNotifier.new);