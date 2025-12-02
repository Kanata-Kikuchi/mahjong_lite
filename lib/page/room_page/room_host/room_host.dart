import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/button/ok_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoomHost extends StatefulWidget {
  const RoomHost({super.key});

  @override
  State<RoomHost> createState() => _RoomHostState();
}

class _RoomHostState extends State<RoomHost> {
  String rooId = 'abc123';

  String hostName = "Aさん";

  String childNameb = 'Bさん';

  String childNamec = 'Cさん';

  String childNamed = 'Dさん';

  @override
  Widget build(BuildContext context) {
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
                            '東 : $hostName',
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
                                        childNameb,
                                        style: MahjongTextStyle.choiceLabelL,
                                      ),
                                      ColumnDivider()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector( // 切り替えボタン.
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() {
                                final buf = childNameb;
                                childNameb = childNamec;
                                childNamec = buf;
                              }),
                              child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                            ),
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
                                        childNamec,
                                        style: MahjongTextStyle.choiceLabelL,
                                      ),
                                      ColumnDivider()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            GestureDetector( // 切り替えボタン.
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() {
                                final buf = childNamec;
                                childNamec = childNamed;
                                childNamed = buf;
                              }),
                              child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
                            ),
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
                                        childNamed,
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
                          OkBtn(
                            label: 'ゲーム開始',
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