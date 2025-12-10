import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/finish_game.dart';
import 'package:mahjong_lite/page/score_share_page.dart/finish_game/popup/result_game/content/result_game_content.dart';
import 'package:mahjong_lite/theme/app_theme.dart';
import 'package:mahjong_lite/page/game_history_page/game_history_page.dart';
import 'package:mahjong_lite/page/round_content_page/round_content_page.dart';
import 'package:mahjong_lite/page/logo_page/logo_page.dart';
import 'package:mahjong_lite/page/room_page/child/room_child.dart';
import 'package:mahjong_lite/page/room_page/host/room_host.dart';
import 'package:mahjong_lite/page/room_page/room_page.dart';
import 'package:mahjong_lite/page/score_share_page.dart/score_share_page.dart';
import 'package:mahjong_lite/page/total_page/total_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);

  final pref = await SharedPreferences.getInstance();
  final String? playerId = pref.getString('playerId');
  final String? roomId = pref.getString('roomId');

  runApp(
    ProviderScope(
      child: MyApp(
        playerId: playerId,
        roomId: roomId
      )
    )
  );
}


class MyApp extends ConsumerWidget {
  const MyApp({
    this.playerId,
    this.roomId,
    super.key
  });

  final String? playerId;
  final String? roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final Widget homeWidget;

    // if (playerId != null && roomId != null) {
    //   homeWidget = ScoreSharePage(
    //     // playerId: playerId,
    //     // roomId: roomId,
    //   );
    // } else {
    //   homeWidget = RoomPage();
    // }

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      // home: FinishGame(),
      // home: ScoreSharePage(),
      home: RoomPage(),
      // home: homeWidget,

      theme: AppTheme.fallback,
      routes: {
        '/logo' : (_) => LogoPage(),
        '/room' : (_) => RoomPage(),
        '/room_host' : (_) => RoomHost(),
        '/room_child' : (_) => RoomChild(),
        '/share' : (_) => ScoreSharePage(),
        '/content' : (_) => RoundContentPage(),
        '/history' : (_) => GameHistoryPage(),
        '/total' : (_) => TotalPage()
      },
      builder: (context, child) {
        final theme = AppTheme.fromMediaQuery(context);
        return CupertinoTheme(
          data: theme,
          child: child!
        );
      }
    );
  }
}