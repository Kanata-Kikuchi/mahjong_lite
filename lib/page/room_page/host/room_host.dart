import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/button/ok_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoomHost extends ConsumerStatefulWidget {
  const RoomHost({super.key});

  @override
  ConsumerState<RoomHost> createState() => _RoomHostState();
}

bool _enable = false;

class _RoomHostState extends ConsumerState<RoomHost> {

  @override
  Widget build(BuildContext context) {

    final player = ref.read(playerProvider.notifier);
    final p = ref.watch(playerProvider);
    final rooId = ref.watch(ruleProvider).id;

    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 55),
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
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(),
                          Text(
                            'ルームID : $rooId',
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
                                Text(
                                  '南',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        p[1].name,
                                        style: MahjongTextStyle.choiceLabelL,
                                      ),
                                      ColumnDivider()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            _enable
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => player.changeNanSya(),
                                  child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                                )
                                : const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15, color: CupertinoColors.systemGrey),
                            Row( // 西.
                              children: [
                                Text(
                                  '西',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        p[2].name,
                                        style: MahjongTextStyle.choiceLabelL,
                                      ),
                                      ColumnDivider()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            _enable
                                ? GestureDetector( // 切り替えボタン.
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => player.changeNanSya(),
                                  child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                                )
                                : const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15, color: CupertinoColors.systemGrey),
                            Row( // 北.
                              children: [
                                Text(
                                  '北',
                                  style: MahjongTextStyle.choiceLabelL,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        p[3].name,
                                        style: MahjongTextStyle.choiceLabelL,
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
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          EnableBtn(
                            label: 'ゲーム開始',
                            enabled: _enable,
                            onTap: () => Navigator.pushNamed(context, '/share'),
                          ),
                          CancelBtn(
                            label: 'ルーム削除',
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              );
            }
          )
        )
      )
    );
  }
}