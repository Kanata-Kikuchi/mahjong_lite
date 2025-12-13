import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class PlotDialog extends StatelessWidget {
  const PlotDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupContent(
      title: '推移グラフ',
      anotation: '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              '未実装',
              style: MahjongTextStyle.choiceLabelL,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '点数の変動を表示する局内容(RoundTable)のデータから、縦軸を点数、横軸を局としてプロットする。また縦軸に関しては割合でプロットする。真ん中を起点(25000点とか)にして、maxをその試合の最高得点とし、minを最低得点とする。最終持ち点が[30, 40, 10, 20]の時、南1局で一度-20になっていたらそれを採用。maxとminが[55, -20]の時25からの割合[30, 45]で上半分と下半分をプロットする。',
                style: MahjongTextStyle.choiceLabelL,
              )
            )
          ),
          SizedBox.shrink()
        ],
      ),
      footer: CupertinoButton(
        child: Text(
          '戻る',
          style: MahjongTextStyle.buttonCancel,
        ),
        onPressed: (){
          Navigator.pop(context);
        }
      )
    );
  }
}