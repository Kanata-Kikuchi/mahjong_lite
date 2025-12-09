import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/socket/socket_game_start_provider.dart';
import 'package:mahjong_lite/socket/socket_provider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double space = 20;

class RoomHost extends ConsumerStatefulWidget {
  const RoomHost({super.key});

  @override
  ConsumerState<RoomHost> createState() => _RoomHostState();
}

bool _enable = true;

class _RoomHostState extends ConsumerState<RoomHost> {

  @override
  Widget build(BuildContext context) {

    ref.listen(socketGameStartProvider, (prev, next) {
      if (next == true) {
        Navigator.pushNamedAndRemoveUntil(context, '/share', (route) => false);
      }
    });

    final player = ref.read(playerProvider.notifier);
    final p = ref.watch(playerProvider);
    final id = ref.watch(ruleProvider).id;

    final length = p.where((w) => w.name != null).length;

    void startGame() {
      final channel = ref.read(socketProvider);
      final roomId = ref.read(ruleProvider).id;

      final msg = {
        'type': 'start_game',
        'payload': {
          'roomId': roomId
        },
      };

      channel.sink.add(jsonEncode(msg));
    }

    void removeRoom() {
      final channel = ref.read(socketProvider);
      final roomId = ref.read(ruleProvider).id;

      final msg = {
        'type': 'remove_room',
        'payload': {
          'roomId': roomId
        }
      };

      channel.sink.add(jsonEncode(msg));
    }

    return CupertinoPageScaffold(
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
                              Expanded(child: _enable && length > 2
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => player.changeNanSya(),
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
                              Expanded(child: _enable && length > 3
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => player.changeSyaPei(),
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
                          onTap: () {
                            removeRoom();
                            Navigator.pop(context);
                          }
                        ),
                        EnableBtn(
                          label: 'ゲーム開始',
                          enabled: _enable,
                          onTap: () {
                            // startGame();
                            ref.read(ruleProvider.notifier).debug();
                            ref.read(playerProvider.notifier).debug();
                            Navigator.pushNamedAndRemoveUntil(context, '/share', (route) => false); // debug用.
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