import 'package:flutter_riverpod/legacy.dart';

enum BootRoute {
  waiting, // 仮.
  room,    // RoomPage.
  share,   // ScoreSharePage.
}

final socketBootRouteProvider = StateProvider<BootRoute>((ref) => BootRoute.waiting);