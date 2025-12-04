import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';
import 'package:mahjong_lite/page/total_page/table/total_table_view.dart';

class TotalPage extends StatelessWidget {
  const TotalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: LayoutPage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 50),
                    SizedBox(
                      height: h / 8,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '集計',
                          style: MahjongTextStyle.title,
                        )
                      )
                    ),
                  ],
                ),
                ColumnDivider(),
                Expanded(
                  child: TotalTableView(),
                ),
                ColumnDivider(),
                SizedBox( // フッター.
                  height: h / 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: w / 4,
                        child: Align( // 親のSizedBoxいっぱいに押せないように.
                          alignment: Alignment.centerLeft,
                          child: BackBtn(
                            label: '試合履歴',
                            onTap: () => Navigator.pop(context),
                            blue: true,
                          ),
                        )
                      ),
                      SizedBox(width: w / 3),
                      SizedBox(width: w / 4)
                    ],
                  ),
                ),
                const SizedBox(height: 15)
              ],
            );
          },
        )
      ),
    );
  }
}