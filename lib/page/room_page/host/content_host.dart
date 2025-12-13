import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/layout/popup/select_sheet.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

/*
  <-----label-----> <-space-> <---------------input--------------->
*/

final double labelBoxWidth = 80;
final double labelInputSpace = 20;
final double inputBoxWidth = 200;
final double inputBoxHeight = 30;

class ContentHost extends ConsumerWidget {
  const ContentHost({
    required this.nameController,
    required this.check,
    super.key
  });

  final TextEditingController nameController;
  final Function(bool) check;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void enableCheck() {
      final enable = ref.read(ruleProvider.notifier).checkHost();
      final textFlag = nameController.text.isNotEmpty;
      check(enable && textFlag);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row( // 名前.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                    '名前',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SizedBox(
                width: inputBoxWidth,
                height: inputBoxHeight,
                child: CupertinoTextField(
                  controller: nameController,
                  placeholder: '10文字以内で設定して下さい',
                  inputFormatters: [LengthLimitingTextInputFormatter(10)], // 最大文字数.
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: CupertinoColors.systemGrey3,
                      width: 1,
                    ),
                  ),
                  style: MahjongTextStyle.choiceBlue,
                  placeholderStyle: MahjongTextStyle.choiceOpa,
                  onChanged: (value) {
                    ref.read(ruleProvider.notifier).name(value);
                    enableCheck();
                  }
                )
              )
            ],
          ),
          Row( // ウマ.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                    'ウマ',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SelectSheet(
                title: 'ウマ',
                choices: Uma.labels,
                placeholder: '    例 : 5 - 10',
                inputBoxWidth: inputBoxWidth,
                onChanged: (value) {
                  final uma = Uma.values.firstWhere((w) => w.label == value);
                  ref.read(ruleProvider.notifier).uma(uma);
                  enableCheck();
                },
              )
            ],
          ),
          Row( // オカ.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                    'オカ',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SelectSheet(
                title: 'オカ',
                choices: Oka.labels,
                placeholder: '    例 : 20000点持ち 25000点返し',
                inputBoxWidth: inputBoxWidth,
                onChanged: (value) {
                  final oka = Oka.values.firstWhere((w) => w.label == value);
                  ref.read(ruleProvider.notifier).oka(oka);
                  enableCheck();
                }
              )
            ],
          ),
          Row( // 飛び.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                    '飛び',
                    style: MahjongTextStyle.choiceLabel,  
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SelectSheet(
                title: "飛び",
                choices: Tobi.labels,
                placeholder: '    例 : あり',
                inputBoxWidth: inputBoxWidth,
                onChanged: (value) {
                  final tobi = Tobi.values.firstWhere((w) => w.label == value);
                  ref.read(ruleProvider.notifier).tobi(tobi);
                  enableCheck();
                }
              )
            ],
          ),
          Row( // 西入.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                  '西入',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SelectSheet(
                title: "西入",
                choices: Syanyu.labels,
                placeholder: '    例 : あり',
                inputBoxWidth: inputBoxWidth,
                onChanged: (value) {
                  final syanyu = Syanyu.values.firstWhere((w) => w.label == value);
                  ref.read(ruleProvider.notifier).syanyu(syanyu);
                  enableCheck();
                }
              )
            ],
          ),
          Row( // アガリ止め.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: const Center(
                  child: Text(
                    'アガリ止め',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SelectSheet(
                title: "アガリ止め",
                choices: Agariyame.labels,
                placeholder: '    例 : あり',
                inputBoxWidth: inputBoxWidth,
                onChanged: (value) {
                  final agariyame = Agariyame.values.firstWhere((w) => w.label == value);
                  ref.read(ruleProvider.notifier).agariyame(agariyame);
                  enableCheck();
                }
              )
            ],
          )
        ]
      )
    );
  }
}