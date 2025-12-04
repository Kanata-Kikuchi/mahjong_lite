import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';
import 'package:mahjong_lite/layout/popup/select_sheet.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row( // 名前.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '名前      ',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SizedBox(
              width: 400,
              height: 40,
              child: CupertinoTextField(
                controller: nameController,
                placeholder: '１０文字以内で設定して下さい',
                inputFormatters: [LengthLimitingTextInputFormatter(10)], // 最大文字数.
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            ),
            const SizedBox(width: 40)
          ],
        ),
        Row( // ウマ.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'ウマ      ',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SelectSheet(
              title: 'ウマ',
              choices: Uma.labels,
              placeholder: '    例 : 5 - 10',
              onChanged: (value) {
                final uma = Uma.values.firstWhere((w) => w.label == value);
                ref.read(ruleProvider.notifier).uma(uma);
                enableCheck();
              },
            ),
            const SizedBox(width: 40)
          ],
        ),
        Row( // オカ.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'オカ      ',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SelectSheet(
              title: 'オカ',
              choices: Oka.labels,
              placeholder: '    例 : 20000点持ち 25000点返し',
              onChanged: (value) {
                final oka = Oka.values.firstWhere((w) => w.label == value);
                ref.read(ruleProvider.notifier).oka(oka);
                enableCheck();
              }
            ),
            const SizedBox(width: 40)
          ],
        ),
        Row( // 飛び.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '飛び      ',
              style: MahjongTextStyle.choiceLabel,  
            ),
            const SizedBox(width: 40),
            SelectSheet(
              title: "飛び",
              choices: Tobi.labels,
              placeholder: '    例 : あり',
              onChanged: (value) {
                final tobi = Tobi.values.firstWhere((w) => w.label == value);
                ref.read(ruleProvider.notifier).tobi(tobi);
                enableCheck();
              }
            ),
            const SizedBox(width: 40)
          ],
        ),
        Row( // 西入.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '西入      ',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SelectSheet(
              title: "西入",
              choices: Syanyu.labels,
              placeholder: '    例 : あり',
              onChanged: (value) {
                final syanyu = Syanyu.values.firstWhere((w) => w.label == value);
                ref.read(ruleProvider.notifier).syanyu(syanyu);
                enableCheck();
              }
            ),
            const SizedBox(width: 40)
          ],
        ),
        Row( // アガリ止め.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'アガリ止め',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SelectSheet(
              title: "アガリ止め",
              choices: Agariyame.labels,
              placeholder: '    例 : あり',
              onChanged: (value) {
                final agariyame = Agariyame.values.firstWhere((w) => w.label == value);
                ref.read(ruleProvider.notifier).agariyame(agariyame);
                enableCheck();
              }
            ),
            const SizedBox(width: 40)
          ],
        )
      ]
    );
  }
}