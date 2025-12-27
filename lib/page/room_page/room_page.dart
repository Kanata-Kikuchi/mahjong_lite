import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/debug/debug_provider.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/button/tab_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/game_notifier.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/reach_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/page/room_page/child/content_child.dart';
import 'package:mahjong_lite/page/room_page/host/content_host.dart';
import 'package:mahjong_lite/socket/flag/socket_enable_join_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_initiative_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {

  ProviderSubscription? _joinSub;

  @override
  void initState() {
    super.initState();

    _joinSub = ref.listenManual(socketEnableJoinProvider, (prev, next) {
      if (!mounted) return;
      if (next == true) {
        Navigator.pushNamed(context, '/room_child');
      }
    });
  }

  @override
  void dispose() {
    _joinSub?.close();
    nameController.dispose();
    roomIDController.dispose();
    super.dispose();
  }

  int _selected = 0;
  bool _enable = false;

  final nameController = TextEditingController();
  final roomIDController = TextEditingController();

  void debugMode() {
    ref.read(debugProvider.notifier).state = true;
    ref.read(gameProvider.notifier).debugMode(); // 3
    ref.read(ruleProvider.notifier).debugMode();
    ref.read(playerProvider.notifier).debugMode();
    ref.read(gameScoreProvider.notifier).debugMode();
    ref.read(roundProvider.notifier).debugMode(); // (2,1)
    ref.read(reachProvider.notifier).debugMode(); // 2
    ref.read(roundTableProvider.notifier).debugMode();
    ref.read(reviseCommentProvider.notifier).debugMode();
    ref.read(initiativeProvider.notifier).state = true;
    Navigator.pushNamedAndRemoveUntil(context, '/share', (route) => false);
  }

  void _check(bool enable) {
    setState(() => _enable = enable);
  }

  void socketCreateRoom(String name) {
    final rule = ref.read(ruleProvider);

    final msg = {
      'type': 'create_room',
      'payload': {
        'name': name,
        'rule': {
          'uma': rule.uma!.label,
          'oka': rule.oka!.label,
          'tobi': rule.tobi!.label,
          'syanyu': rule.syanyu!.label,
          'agariyame': rule.agariyame!.label
        }
      }
    };

    ref.read(socketProvider.notifier).send(msg);
  }

  void socketJoinRoom(String name) {
    final rule = ref.read(ruleProvider);

    final msg = {
      'type': 'join_room',
      'payload': {
        'name': name,
        'roomId': rule.id
      }
    };

    ref.read(socketProvider.notifier).send(msg);
  }

  @override
  Widget build(BuildContext context) {

    final rule = ref.read(ruleProvider.notifier);

    return CupertinoPageScaffold(
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return LayoutPage(
              width: w * 2 / 3,
              height: h,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox( // タブボタン.
                    height: h / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TabBtn(
                          label: 'ルームを作る',
                          selected: _selected == 0,
                          onTap: () {
                            setState(() {
                              _selected = 0;
                              _enable = false;
                            });
                            rule.reset();
                          }
                        ),
                        TabBtn(
                          label: 'ルームに入る',
                          selected: _selected == 1,
                          onTap: () {
                            setState(() {
                              _selected = 1;
                              if (roomIDController.text.isEmpty) {
                                _enable = false;
                              } else {
                                _enable = true;
                              }
                            });
                            rule.reset();
                          }
                        )
                      ],
                    )
                  ),
                  const ColumnDivider(),
                  Expanded(
                    child: _selected == 0
                        ? ContentHost(
                            nameController: nameController,
                            check: _check,
                          )
                        : ContentChild(
                            nameController: nameController,
                            roomIDController: roomIDController,
                            check: _check,
                            )
                  ),
                  const ColumnDivider(),
                  SizedBox( // フットボタン.
                    height: h / 8,
                    child: _selected == 0
                        ? EnableBtn(
                            label: "作る",
                            enabled: _enable,
                            bold: true,
                            onTap: () {
                              socketCreateRoom(nameController.text);
                              Navigator.pushNamed(context, '/room_host');
                            }
                          )
                        : EnableBtn(
                            label: "入る",
                            enabled: _enable,
                            bold: true,
                            onTap: () {
                              // Navigator.pushNamed(context, '/room_child'); // debug用.
                              if (nameController.text == 'debug' && roomIDController.text == 'debug') {
                                // print('debugMode');
                                debugMode();
                              } else {
                                socketJoinRoom(nameController.text);
                              }
                            }
                          )
                  ),
                ],
              ),
            );
          }
        )
      )
    );
  }
}