import 'package:flutter_riverpod/legacy.dart';

// SharedPreferencesの値をどこからでも取れるように.
final socketPlayerIdProvider = StateProvider<String?>((ref) => null);