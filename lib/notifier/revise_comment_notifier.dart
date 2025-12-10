import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviseCommentNotifier extends Notifier<Map<int, String>> {

  @override
  Map<int, String> build() => {};

  void debugMode() {
    state = {
      1: 'debug_Bのあがりだったのに間違えてdebug_Cで入力した'
    };
  }

  void reviseCommentSet({
    required Map<String, String> comment
  }) {
    state = comment.map((key, value) => MapEntry(int.parse(key), value));
  }

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