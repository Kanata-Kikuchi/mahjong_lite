import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/game_model.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/page/total_page/popup/total_dialog.dart';
import 'package:mahjong_lite/page/total_page/popup/total_popup.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class TotalTableView extends ConsumerWidget {
  const TotalTableView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final initialName = ref.read(playerProvider.notifier).initialName();
    final gameList = ref.watch(gameScoreProvider.notifier).sortName(initialName: initialName);
    final buf = ref.read(gameScoreProvider.notifier).sumScore(); // List(name, sumScore).
    final sumScore = [
      buf.firstWhere((w) => w.$1 == initialName[0]).$2,
      buf.firstWhere((w) => w.$1 == initialName[1]).$2,
      buf.firstWhere((w) => w.$1 == initialName[2]).$2,
      buf.firstWhere((w) => w.$1 == initialName[3]).$2
    ];

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
                      '  ',
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
                child: Text(
                  gameList[i].score1st!.$3,
                  style: MahjongTextStyle.tableSel,
                )
              ),
              Expanded(
                flex: 4,
                child: Text(
                  gameList[i].score2nd!.$3,
                  style: MahjongTextStyle.tableSel,
                )
              ),
              Expanded(
                flex: 4,
                child: Text(
                  gameList[i].score3rd!.$3,
                  style: MahjongTextStyle.tableSel,
                )
              ),
              Expanded(
                flex: 4,
                child: Text(
                  gameList[i].score4th!.$3,
                  style: MahjongTextStyle.tableSel,
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
                  child: Text(
                    initialName[0],

                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    initialName[1],

                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    initialName[2],

                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    initialName[3],

                  ),
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
            flex: 8,
            child: ListView.separated(
              itemCount: gameList.length,
              itemBuilder: (context, i) => gameContent(gameList, i),
              separatorBuilder: (context, i) => ColumnDivider(),
            )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '合計',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                  if (gameList.length == 1)
                    ...[
                      Expanded(
                        flex: 17,
                        child: SizedBox.shrink(),
                      )
                    ]
                  else
                    ...[
                      Expanded(
                        flex: 4,
                        child: Text(
                          sumScore[0],
                          style: MahjongTextStyle.tableSel,
                        )
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          sumScore[1],
                          style: MahjongTextStyle.tableSel,
                        )
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          sumScore[2],
                          style: MahjongTextStyle.tableSel,
                        )
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          sumScore[3],
                          style: MahjongTextStyle.tableSel,
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TotalPopup()
                        )
                      )
                    ]
                ]
              )
            )
          )
        ],
      )
    );
  }
}