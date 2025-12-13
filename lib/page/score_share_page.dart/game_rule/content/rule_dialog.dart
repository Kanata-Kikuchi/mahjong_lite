import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/popup/popup_content.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double labelWidth = 80;
final double contentWidth = 150;
final double space = 30;

class RuleDialog extends ConsumerWidget {
  const RuleDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final rule = ref.read(ruleProvider);
    final labelList = [
      'ウマ',
      'オカ',
      '飛び',
      '西入',
      'アガリやめ'
    ];
    final contentList = [
      rule.uma!.label,
      rule.oka!.label,
      rule.tobi!.label,
      rule.syanyu!.label,
      rule.agariyame!.label
    ];

    return PopupContent(
      title: 'ルール',
      anotation: '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: space),
              SizedBox(
                width: labelWidth,
                child: Center(
                  child: Text(
                    labelList[i],
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(
                width: contentWidth,
                child: Center(
                  child: Text(
                    contentList[i],
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: space)
            ],
          );
        })
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