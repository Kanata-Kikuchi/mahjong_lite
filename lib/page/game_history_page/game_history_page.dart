import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/back_btn.dart';
import 'package:mahjong_lite/layout/button/next_btn.dart';
import 'package:mahjong_lite/page/game_history_page/table/game_table_view.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double btnPaddingHorizontal = 30;

class GameHistoryPage extends StatelessWidget {
  const GameHistoryPage({super.key});

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
                        '試合履歴',
                        style: MahjongTextStyle.tabBlack,
                      )
                    ]
                  )
                ),
                const ColumnDivider(),
                const Expanded(
                  child: GameTableView(),
                ),
                const ColumnDivider(),
                SizedBox( // フッター.
                  height: h / 8,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: btnPaddingHorizontal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackBtn(
                          label: '点数表示',
                          onTap: () => Navigator.pop(context),
                          blue: true,
                        ),
                        NextBtn(
                          label: '集計',
                          onTap: () => Navigator.pushNamed(context, '/total')
                        )
                      ],
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