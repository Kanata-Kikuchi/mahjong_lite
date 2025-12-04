import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/cancel_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoomChild extends StatelessWidget {
  const RoomChild({super.key});

  final String rooId = 'abc123';

  final String hostName = "Aさん";

  final String childNameb = 'Bさん';

  final String childNamec = 'Cさん';

  final String childNamed = 'Dさん';

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
                            const SizedBox(),
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
                            const SizedBox(),
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
                          CancelBtn(
                            label: '退出',
                            onTap: () => Navigator.pop(context),
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
      )
    );
  }
}