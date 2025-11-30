import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/model/child_input.dart';

class ChildNotifier extends Notifier<Child> {

  @override
  Child build() {
    return Child(
      name: '',
      id: ''
    );
  }

  void name(String name) {
    state = state.copyWith(name: name);
  }

  void id(String id) {
    state = state.copyWith(id: id);
  }

}

final childNotifier = NotifierProvider<ChildNotifier, Child>(ChildNotifier.new);