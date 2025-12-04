import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ContentChild extends ConsumerStatefulWidget {
  const ContentChild({
    required this.nameController,
    required this.check,
    super.key
  });

  final TextEditingController nameController;
  final Function(bool) check;

  @override
  ConsumerState<ContentChild> createState() => _ContentChildState();
}

final roomIDController = TextEditingController();

class _ContentChildState extends ConsumerState<ContentChild> {
  @override
  Widget build(BuildContext context) {

    void enableCheck() {
      final enable = ref.read(ruleProvider.notifier).checkChild();
      final textFlag = widget.nameController.text.isNotEmpty && roomIDController.text.isNotEmpty;
      widget.check(enable && textFlag);
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
                controller: widget.nameController,
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
        Row( // ルームID.
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'ルームID  ',
              style: MahjongTextStyle.choiceLabel,
            ),
            const SizedBox(width: 40),
            SizedBox(
              width: 400,
              height: 40,
              child: CupertinoTextField(
                controller: roomIDController,
                placeholder: 'ルームIDを入力',
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
                  ref.read(ruleProvider.notifier).id(value);
                  enableCheck();
                }
              )
            ),
            const SizedBox(width: 40)
          ],
        )
      ]
    );
  }
}