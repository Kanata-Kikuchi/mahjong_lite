import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/round_table.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/revise/input_revise.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoundTableView extends ConsumerWidget {
  const RoundTableView({
    // required this.list,
    super.key
  });

  // final List list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final list = ref.watch(roundTableProvider);
    final name = ref.watch(playerProvider).map((m) => m.name).toList();

    Widget roundContent(List<RoundTable> list, int i) {

      if (list.length == i + 1) {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      list[i].kyoku,
                      style: MahjongTextStyle.tableLabel,
                    ),
                    Text(
                      '  ${list[i].honba}',
                      style: MahjongTextStyle.tableAnotation,
                    )
                  ],
                )
              ),
              Expanded(
                flex: 16,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '試合中',
                    style: MahjongTextStyle.tableSel,
                  )
                )
              ),
              Expanded(
                flex: 3,
                child: SizedBox.shrink()
              )
            ]
          )
        );
      } else {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      list[i].kyoku,
                      style: MahjongTextStyle.tableLabel,
                    ),
                    Text(
                      '  ${list[i].honba}',
                      style: MahjongTextStyle.tableAnotation,
                    )
                  ],
                )
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].p0.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].p1.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].p2.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].p3.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: i == list.length - 2
                      ? InputRevise()
                      : SizedBox.shrink()
                )
              )
            ]
          )
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 8),
            child:Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 4,
                  child: Text(name[0]),
                ),
                Expanded(
                  flex: 4,
                  child: Text(name[1]),
                ),
                Expanded(
                  flex: 4,
                  child: Text(name[2]),
                ),
                Expanded(
                  flex: 4,
                  child: Text(name[3]),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.shrink(),
                )
              ],
            ),
          ),
          ColumnDivider(),
          SizedBox(),
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              itemBuilder: (context, i) => roundContent(list, i),
              separatorBuilder: (context, i) => ColumnDivider(),
            )
          )
        ],
      )
    );
  }
}