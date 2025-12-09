import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';
import 'package:mahjong_lite/page/total_page/table/total_table_view.dart';

final double btnPaddingHorizontal = 30;

class TotalPage extends StatelessWidget {
  const TotalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: LayoutPage(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;

            return Column(
              children: [
                SizedBox( // ヘッダー.
                  height: h / 8,
                  child: Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        '集計',
                        style: MahjongTextStyle.tabBlack,
                      )
                    ]
                  )
                ),
                ColumnDivider(),
                Expanded(
                  child: TotalTableView(),
                ),
                ColumnDivider(),
                SizedBox( // フッター.
                  height: h / 8,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: btnPaddingHorizontal),
                    child: BackBtn(
                      label: '試合履歴',
                      onTap: () => Navigator.pop(context),
                      blue: true,
                    ),
                  )
                )
              ],
            );
          },
        )
      ),
    );
  }
}