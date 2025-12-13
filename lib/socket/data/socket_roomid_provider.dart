import 'package:flutter_riverpod/legacy.dart';

// SharedPreferencesの値をどこからでも取れるように.
final socketRoomIdProvider = StateProvider<String?>((ref) => null);