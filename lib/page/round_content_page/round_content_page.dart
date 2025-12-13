import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/page/round_content_page/table/round_table_view.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double btnPaddingHorizontal = 30;

class RoundContentPage extends StatelessWidget {
  const RoundContentPage({super.key});

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
                  child: const Row(
                    children: [
                      SizedBox(width: 30),
                      Text(
                        '局内容',
                        style: MahjongTextStyle.tabBlack,
                      )
                    ]
                  )
                ),
                const ColumnDivider(),
                const Expanded(
                  child: RoundTableView(),
                ),
                const ColumnDivider(),
                SizedBox( // フッター.
                  height: h / 8,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: btnPaddingHorizontal),
                    child: BackBtn(
                      label: '点数表示',
                      onTap: () => Navigator.pop(context),
                      blue: true,
                    )
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