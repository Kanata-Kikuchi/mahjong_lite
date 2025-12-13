import 'package:flutter_riverpod/legacy.dart';

/// 「ローカルIDから復帰を試みるフラグ.
final socketResumeEnabledProvider = StateProvider<bool>((ref) => false);