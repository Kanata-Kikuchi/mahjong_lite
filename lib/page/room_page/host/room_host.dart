import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/flag/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double space = 20;

class RoomHost extends ConsumerStatefulWidget {
  const RoomHost({super.key});

  @override
  ConsumerState<RoomHost> createState() => _RoomHostState();
}

class _RoomHostState extends ConsumerState<RoomHost> {

  ProviderSubscription? _startSub;

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
  }

  @override
  void dispose() {
    _startSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final player = ref.read(playerProvider.notifier);
    final p = ref.watch(playerProvider);
    final id = ref.watch(ruleProvider).id;

    final length = p.where((w) => w.name != null).length;
    final enable = p.where((w) => w.name != null).length == 4;

    void startGame() {
      final roomId = ref.read(ruleProvider).id;
      final initialScore = ref.read(playerProvider)[0].score;

      final msg = {
        'type': 'start_game',
        'payload': {
          'roomId': roomId,
          'initialScore': initialScore
        },
      };

      ref.read(socketProvider.notifier).send(msg);
    }

    void removeRoom() {
      final roomId = ref.read(ruleProvider).id;

      final msg = {
        'type': 'remove_room',
        'payload': {
          'roomId': roomId
        }
      };

      ref.read(socketProvider.notifier).send(msg);
    }

    void changeSeat() {
      final roomId = ref.read(ruleProvider).id;
      final players = ref.read(playerProvider);

      final msg = {
        'type': 'change_seat',
        'payload': {
          'roomId': roomId,
          'players': players.map((m) => {
            'name': m.name
          }).toList()
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
                  SizedBox( // タブ.
                    height: h / 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(),
                        Text(
                          'ルームID : $id',
                          style: MahjongTextStyle.tabBlack
                        ),
                        Text(
                          '東 : ${p[0].name}',
                          style: MahjongTextStyle.tabAnnotation
                        )
                      ],
                    )
                  ),
                  ColumnDivider(),
                  /* -------------------------------------------------------------------- */
                  Expanded( // ボディ部分.
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row( // 南.
                            children: [
                              SizedBox(
                                width: space,
                                child: Text(
                                  '南',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      p[1].name ?? '',
                                      style: MahjongTextStyle.choiceLabel,
                                    ),
                                    ColumnDivider()
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: space),
                              Expanded(child: length > 2
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    player.changeNanSya();
                                    changeSeat();
                                  },
                                  child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                                )
                                : const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15, color: CupertinoColors.systemGrey),)
                            ],
                          ),
                          Row( // 西.
                            children: [
                              SizedBox(
                                width: space,
                                child: Text(
                                  '西',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      p[2].name ?? '',
                                      style: MahjongTextStyle.choiceLabel,
                                    ),
                                    ColumnDivider()
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: space),
                              Expanded(child: length > 3
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    player.changeSyaPei();
                                    changeSeat();
                                  },
                                  child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                                )
                                : const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15, color: CupertinoColors.systemGrey),)
                            ],
                          ),
                          Row( // 北.
                            children: [
                              SizedBox(
                                width: space,
                                child: Text(
                                  '北',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      p[3].name ?? '',
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
                  ColumnDivider(),
                  /* -------------------------------------------------------------------- */
                  SizedBox( // フットボタン.
                    height: h / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CancelBtn(
                          label: 'ルーム削除',
                          red: true,
                          onTap: () {
                            removeRoom();
                            Navigator.pop(context); // 調整。回線次第.
                          }
                        ),
                        EnableBtn(
                          label: 'ゲーム開始',
                          enabled: enable,
                          onTap: () {
                            startGame();
                            // Navigator.pushNamedAndRemoveUntil(context, '/share', (route) => false); // debug用.
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