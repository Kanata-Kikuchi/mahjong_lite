import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/game_model.dart';
import 'package:mahjong_lite/notifier/game_score_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class GameTable extends ConsumerWidget {
  const GameTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final gameList = ref.watch(gameScoreProvider);
    final name = ref.read(playerProvider.notifier);

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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      name.name(initial: gameList[i].score1st!.$1),
                      style: MahjongTextStyle.tableSel,
                    ),
                    Text(
                      gameList[i].score1st!.$2,
                      style: MahjongTextStyle.tableAnotation,
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      name.name(initial: gameList[i].score2nd!.$1),
                      style: MahjongTextStyle.tableSel,
                    ),
                    Text(
                      gameList[i].score2nd!.$2,
                      style: MahjongTextStyle.tableAnotation,
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      name.name(initial: gameList[i].score3rd!.$1),
                      style: MahjongTextStyle.tableSel,
                    ),
                    Text(
                      gameList[i].score3rd!.$2,
                      style: MahjongTextStyle.tableAnotation,
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      name.name(initial: gameList[i].score4th!.$1),
                      style: MahjongTextStyle.tableSel,
                    ),
                    Text(
                      gameList[i].score4th!.$2,
                      style: MahjongTextStyle.tableAnotation,
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    CupertinoIcons.right_chevron,
                    color: CupertinoColors.activeBlue,
                    size: 17,
                  )
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
                  child: Text('１着'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('２着'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('３着'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('４着'),
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