import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mahjong_lite/theme/app_theme.dart';
import 'package:mahjong_lite/page/game_history_page/game_history_page.dart';
import 'package:mahjong_lite/page/round_content_page/round_content_page.dart';
import 'package:mahjong_lite/page/logo_page/logo_page.dart';
import 'package:mahjong_lite/page/room_page/room_child/room_child.dart';
import 'package:mahjong_lite/page/room_page/room_host/room_host.dart';
import 'package:mahjong_lite/page/room_page/room_page.dart';
import 'package:mahjong_lite/page/score_share_page.dart/score_share_page.dart';
import 'package:mahjong_lite/page/total_page/total_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);

  const app = MyApp();

  const scope = ProviderScope(child: app);

  runApp(scope);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: ScoreSharePage(),
      // home: RoomPage(),
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