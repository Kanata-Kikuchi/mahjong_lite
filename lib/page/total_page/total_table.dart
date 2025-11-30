import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/model/game_model.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class TotalTable extends StatelessWidget {
  const TotalTable({super.key});

  @override
  Widget build(BuildContext context) {

    List list = [
      Game(game: 1, time: 00, score1st: (0, 25000), score2nd: (1, 2500), score3rd: (2, 250), score4th: (3, 25)),
      Game(game: 2, time: 00, score1st: (1, 25000), score2nd: (2, 2500), score3rd: (3, 250), score4th: (0, 25)),
      Game(game: 3, time: 00, score1st: (2, 25000), score2nd: (3, 2500), score3rd: (0, 250), score4th: (1, 25)),
      Game(game: 0, time: 00, score1st: (0, 25000), score2nd: (1, 2500), score3rd: (2, 250), score4th: (3, 25)),
    ];

    Widget gameContent(List list, int i) {
      if(list[i].game == 0) {
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
                      '第${list[i - 1].game + 1}試合',
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
                      '第${list[i].game}試合',
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
                  list[i].score1st.$2.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].score2nd.$2.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].score3rd.$2.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  list[i].score4th.$2.toString(),
                  style: MahjongTextStyle.tableSel,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox.shrink()
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
                  child: Text('Aさん'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Bさん'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Cさん'),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Dさん'),
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
              itemBuilder: (context, i) => gameContent(list, i),
              separatorBuilder: (context, i) => ColumnDivider(),
            )
          )
        ],
      )
    );
  }
}