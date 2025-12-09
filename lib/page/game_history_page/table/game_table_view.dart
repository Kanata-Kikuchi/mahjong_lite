import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/game_model.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class GameTableView extends ConsumerWidget {
  const GameTableView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    /*
      横軸 : 着順
      縦軸 : 各試合
    */

    final gameList = ref.watch(gameScoreProvider);
    final scoreList = ref.watch(gameScoreProvider.notifier).score();

    Widget gameContent(List<Game> gameList, int i) {
      if(gameList.length == i + 1) {
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
                      gameList[i].game,
                      style: MahjongTextStyle.tableLabel,
                    ),
                    Text(
                      '',
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
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox.shrink()
                )
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
                      gameList[i].game,
                      style: MahjongTextStyle.tableLabel,
                    ),
                    Text(
                      '  ',
                      style: MahjongTextStyle.tableAnotation,
                    )
                  ],
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        gameList[i].score1st!.$1,
                        style: MahjongTextStyle.tableSel,
                      ),
                      Text(
                        '  ${scoreList[i][3].toString()}点',
                        style: MahjongTextStyle.tableAnotation,
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        gameList[i].score2nd!.$1,
                        style: MahjongTextStyle.tableSel,
                      ),
                      Text(
                        '  ${scoreList[i][2].toString()}点',
                        style: MahjongTextStyle.tableAnotation,
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        gameList[i].score3rd!.$1,
                        style: MahjongTextStyle.tableSel,
                      ),
                      Text(
                        '  ${scoreList[i][1].toString()}点',
                        style: MahjongTextStyle.tableAnotation,
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        gameList[i].score4th!.$1,
                        style: MahjongTextStyle.tableSel,
                      ),
                      Text(
                        '  ${scoreList[i][0].toString()}点',
                        style: MahjongTextStyle.tableAnotation,
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                flex: 1,
                child: SizedBox.shrink(),
                /* ここに押すと試合の点数推移が表示されるグラフを作りたい */
                // child: Align(
                //   alignment: Alignment.centerRight,
                //   child: Icon(
                //     CupertinoIcons.right_chevron,
                //     color: CupertinoColors.activeBlue,
                //     size: 17,
                //   )
                // )
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
                      '1st',
                      style: MahjongTextStyle.tableSel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      '2nd',
                      style: MahjongTextStyle.tableSel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      '3rd',
                      style: MahjongTextStyle.tableSel,
                    )
                  )
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      '4th',
                      style: MahjongTextStyle.tableSel,
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
              itemCount: gameList.length,
              itemBuilder: (context, i) => gameContent(gameList, i),
              separatorBuilder: (context, i) => ColumnDivider(),
            )
          )
        ],
      )
    );
  }
}