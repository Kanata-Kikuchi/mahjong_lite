import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/flag/socket_enable_join_provider.dart';
import 'package:mahjong_lite/socket/flag/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/data/socket_playerid_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoomChild extends ConsumerStatefulWidget {
  const RoomChild({super.key});

  @override
  ConsumerState<RoomChild> createState() => _RoomChildState();
}

class _RoomChildState extends ConsumerState<RoomChild> {

  ProviderSubscription? _startSub;
  ProviderSubscription? _enableSub;

  @override
  void initState() {
    super.initState();

    _startSub = ref.listenManual(socketGameStartProvider, (prev, next) {
      if (!mounted) return;
      if (next == true) {
        Navigator.pushNamedAndRemoveUntil(context, '/share', (route) => false);
        ref.read(socketGameStartProvider.notifier).state = false;
      }
    });

    _enableSub = ref.listenManual(socketEnableJoinProvider, (prev, next) {
      if (!mounted) return;
      if (next == false) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _startSub?.close();
    _enableSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final roomId = ref.read(ruleProvider).id;
    final name = ref.watch(playerProvider).map((m) => m.name).toList();

    void exitRoom() {
      final roomId = ref.read(ruleProvider).id;
      final playerId = ref.read(socketPlayerIdProvider);

      final msg = {
        'type': 'exit_room',
        'payload': {
          'roomId': roomId,
          'playerId': playerId,
        }
      };

      ref.read(socketProvider.notifier).send(msg);
    }

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return LayoutPage( // 背景のポップ.
              width: w / 2,
              height: h,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox( // タブボタン.
                    height: h / 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(),
                        Text(
                          'ルームID : $roomId',
                          style: MahjongTextStyle.tabBlack
                        ),
                        Text(
                          '東 : ${name[0]}',
                          style: MahjongTextStyle.tabAnnotation
                        )
                      ],
                    )
                  ),
                  const ColumnDivider(),
                  /* -------------------------------------------------------------------- */
                  Expanded( // ボディ部分.
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row( // 南.
                            children: [
                              const Text(
                                '南',
                                style: MahjongTextStyle.choiceLabelL,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      name[1] ?? '',
                                      style: MahjongTextStyle.choiceLabel,
                                    ),
                                    const ColumnDivider()
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(),
                          Row( // 西.
                            children: [
                              const Text(
                                '西',
                                style: MahjongTextStyle.choiceLabelL,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      name[2] ?? '',
                                      style: MahjongTextStyle.choiceLabel,
                                    ),
                                    const ColumnDivider()
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(),
                          Row( // 北.
                            children: [
                              const Text(
                                '北',
                                style: MahjongTextStyle.choiceLabelL,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      name[3] ?? '',
                                      style: MahjongTextStyle.choiceLabel,
                                    ),
                                    ColumnDivider()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                  const ColumnDivider(),
                  /* -------------------------------------------------------------------- */
                  SizedBox( // フットボタン.
                    height: h / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CancelBtn(
                          label: '退出',
                          red: true,
                          onTap: () {
                            exitRoom();
                          },
                        )
                      ],
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