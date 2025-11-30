import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviseCommentNotifier extends Notifier<String> {

  @override
  String build() => '';

  void set(String text) {
    state = text;
  }

}

final reviseCommentProvider = NotifierProvider<ReviseCommentNotifier, String>(ReviseCommentNotifier.new);