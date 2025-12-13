import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mahjong_lite/socket/data/socket_boot_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_resume_enabled_provider.dart';
import 'package:mahjong_lite/socket/socket_listener_notifier.dart';
import 'package:mahjong_lite/socket/data/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/socket/socket_resume_notifier.dart';
import 'package:mahjong_lite/socket/data/socket_roomid_provider.dart';
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
        roomId: roomId,
      )
    )
  );
}

// 調整。あとで直すところ.
// debug用。あとで消すかコメントアウト.

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    this.playerId,
    this.roomId,
    super.key
  });

  final String? playerId;
  final String? roomId;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (widget.playerId != null && widget.roomId != null) {
        /*
          <復帰の条件>
            SharedPreferenceにIDがあるかどうか。ルームを作るとき(親)とルームに入るとき(子)にsetStringされる
            ルーム削除(親)かルーム退出(子)でremoveする。ScoreSharePageに遷移後はセッションを削除するまで保持される
            1: main.dart                     : buildされref.watch(socketListenerProvider, socketResumeProvider);が購読準備
            2: socket_resume_notifier.dart   : IDのlistenでtrySend()が実行されるが、if (status != SocketStatus.connected) return;ではじく
            3: main.dart                     : BootRoute.waitingに状態を変更
            4: main.dart                     : ref.read(socketProvider.notifier).connect()を実行
            5: socket_provider.dart          : _channel = WebSocketChannel.connect(Uri.parse(url));、4を受けてコネクト開始
            6: socket_provider.dart          : state = SocketStatus.connected; 状態を変更
            7: socket_listener_notifier.dart : 4のstate = SocketStatus.connectedを受けてattach()が実行され購読開始(7,8はほぼ同タイミング問題なし)
            8: socket_resume_notifier.dart   : SocketStatusのlistenでtrySendが正常に実行され'resume_room'がサーバーに送られる(7,8はほぼ同タイミング問題なし)
            9: socket_listener_notifier.dart : サーバーから復帰成功ができるか返答を受け、成功ならstate = BootRoute.share、失敗ならstate = BootRoute.room
          <UI表示の順番>
            LogoPage => 9を受けて RoomPage or ScoreSharePage
        */
        ref.read(socketResumeEnabledProvider.notifier).state = true;
        ref.read(socketPlayerIdProvider.notifier).state = widget.playerId;
        ref.read(socketRoomIdProvider.notifier).state = widget.roomId;
        ref.read(socketBootRouteProvider.notifier).state = BootRoute.waiting; // 仮.
      } else { // 端末のローカルストレージにもIDがない、初回.
        /*
          <初回>
            1: main.dart                     : buildされref.watch(socketListenerProvider, socketResumeProvider);が購読準備
            2: socket_resume_notifier.dart   : IDのlistenでtrySend()が実行されるが、if (status != SocketStatus.connected) return;ではじく
            3: main.dart                     : BootRoute.roomに状態を変更
            4: main.dart                     : ref.read(socketProvider.notifier).connect()を実行
            5: socket_provider.dart          : _channel = WebSocketChannel.connect(Uri.parse(url));、4を受けてコネクト開始
            6: socket_provider.dart          : state = SocketStatus.connected; 状態を変更
            7: socket_listener_notifier.dart : 6のstate = SocketStatus.connectedを受けてattach()が実行され購読開始
            8: socket_resume_notifier.dart   : connectedを受けてtrySend()が呼ばれるが、BootRoute.roomなので送信されない
          <UI表示の順番>
            LogoPage => RoomPage => ScoreSharePage
        */
        ref.read(socketResumeEnabledProvider.notifier).state = false;
        ref.read(socketBootRouteProvider.notifier).state = BootRoute.room;
      }

      await ref.read(socketProvider.notifier).connect();
    });
  }


  @override
  Widget build(BuildContext context) {
    ref.watch(socketListenerProvider);
    ref.watch(socketResumeProvider);

    final Widget homeWidget;
    final boot = ref.watch(socketBootRouteProvider);

    switch (boot) {
      case BootRoute.waiting:
        // homeWidget = const LogoPage(); // 仮.
        homeWidget = const RoomPage();
        break;
      case BootRoute.room:
        homeWidget = const RoomPage();
        break;
      case BootRoute.share:
        homeWidget = const ScoreSharePage();
        break;
    }

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
      theme: AppTheme.fallback,
      routes: {
        '/logo' : (_) => const LogoPage(),
        '/room' : (_) => const RoomPage(),
        '/room_host' : (_) => const RoomHost(),
        '/room_child' : (_) => const RoomChild(),
        '/share' : (_) => const ScoreSharePage(),
        '/content' : (_) => const RoundContentPage(),
        '/history' : (_) => const GameHistoryPage(),
        '/total' : (_) => const TotalPage()
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