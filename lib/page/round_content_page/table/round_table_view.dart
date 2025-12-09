import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/round_table.dart';
import 'package:mahjong_lite/notifier/game_set_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/popup/input_revise/input_revise.dart';
import 'package:mahjong_lite/page/round_content_page/popup/show_comment/show_comment.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class RoundTableView extends ConsumerWidget {
  const RoundTableView({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    /*
      横軸 : 今の試合の席順(東 → 南 → 西 → 北)　=> initialName()
      縦軸 : 各局
    */
    
    final initialScore = ref.read(playerProvider.notifier).initScore();
    final list = ref.watch(roundTableProvider);
    final diff = ref.read(roundTableProvider.notifier).diffrenceScore(initialScore: initialScore);
    final name = ref.watch(playerProvider).map((m) => m.name!).toList();
    final gameSet = ref.watch(gameSetProvider);

    final diffString = diff.map((m) => m.map((d) {
        if (d > 0) {
          return '+${d.toString()}';
        } else if (d < 0) {
          return '-${(-d).toString()}';
        } else {
          return '0';
        }
      }).toList()
    ).toList();

    Widget roundContent(List<RoundTable> list, List<List<String>> diff, int i) {

      if (list.length == i + 1 && !gameSet) {
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
                flex: 1,
                child: SizedBox.shrink()
              )
            ]
          )
        );
      } else if (list[i].revise ?? false) {
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 8),
          child: Stack(
            children: [
              Row(
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
                    child: Center(
                      child: Text(
                        list[i].p0.toString(),
                        style: MahjongTextStyle.tableSel,
                      )
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        list[i].p1.toString(),
                        style: MahjongTextStyle.tableSel,
                      )
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        list[i].p2.toString(),
                        style: MahjongTextStyle.tableSel,
                      )
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        list[i].p3.toString(),
                        style: MahjongTextStyle.tableSel,
                      )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: i == list.length - 2
                          ? InputRevise() // 修正ポップアップ.
                          : SizedBox.shrink()
                    )
                  )
                ]
              ),
              Row(
                children: [
                  Expanded( // 上に書く赤い横線.
                    flex: 19,
                    child: Container(height: 1, color: CupertinoColors.systemRed)
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ShowComment(index:i)
                    )
                  )
                ],
              )
            ],
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
                child: Center(
                  child: Text(
                    diff[i][0] != '0'
                        ? '${list[i].p0.toString()} ( ${diff[i][0]} )'
                        : list[i].p0.toString(),
                    style: MahjongTextStyle.tableSel,
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    diff[i][1] != '0'
                        ? '${list[i].p1.toString()} ( ${diff[i][1]} )'
                        : list[i].p1.toString(),
                    style: MahjongTextStyle.tableSel,
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    diff[i][2] != '0'
                        ? '${list[i].p2.toString()} ( ${diff[i][2]} )'
                        : list[i].p2.toString(),
                    style: MahjongTextStyle.tableSel,
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    diff[i][3] != '0'
                        ? '${list[i].p3.toString()} ( ${diff[i][3]} )'
                        : list[i].p3.toString(),
                    style: MahjongTextStyle.tableSel,
                  )
                )
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: i == list.length - 2
                      ? InputRevise() // 修正ポップアップ.
                      : SizedBox.shrink()
                )
              )
            ]
          )
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                  child: Center(
                    child: Text(
                      name[0],
                      style: MahjongTextStyle.tableLabel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      name[1],
                      style: MahjongTextStyle.tableLabel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      name[2],
                      style: MahjongTextStyle.tableLabel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      name[3],
                      style: MahjongTextStyle.tableLabel,
                    )
                  )
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.shrink(),
                )
              ],
            ),
          ),
          ColumnDivider(),
          Expanded(
            child: ListView.separated(
              itemCount: gameSet
                  ? list.length - 1
                  : list.length,
              itemBuilder: (context, i) => roundContent(list, diffString, i),
              separatorBuilder: (context, i) => ColumnDivider(),
            )
          )
        ],
      )
    );
  }
}