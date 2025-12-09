import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/notifier/rule_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

/*
  <-----label-----> <-space-> <---------------input--------------->
*/

final double labelBoxWidth = 80;
final double labelInputSpace = 20;
final double inputBoxWidth = 200;
final double inputBoxHeight = 30;

class ContentChild extends ConsumerStatefulWidget {
  const ContentChild({
    required this.nameController,
    required this.roomIDController,
    required this.check,
    super.key
  });

  final TextEditingController nameController;
  final TextEditingController roomIDController;
  final Function(bool) check;

  @override
  ConsumerState<ContentChild> createState() => _ContentChildState();
}

class _ContentChildState extends ConsumerState<ContentChild> {
  @override
  Widget build(BuildContext context) {

    void enableCheck() {
      final enable = ref.read(ruleProvider.notifier).checkChild();
      final textFlag = widget.nameController.text.isNotEmpty && widget.roomIDController.text.isNotEmpty;
      widget.check(enable && textFlag);
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
                child: Center(
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
                  controller: widget.nameController,
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
          Row( // ルームID.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: labelBoxWidth,
                child: Center(
                  child: Text(
                    'ルームID',
                    style: MahjongTextStyle.choiceLabel,
                  )
                )
              ),
              SizedBox(width: labelInputSpace),
              SizedBox(
                width: inputBoxWidth,
                height: inputBoxHeight,
                child: CupertinoTextField(
                  controller: widget.roomIDController,
                  placeholder: '6文字のルームIDを入力',
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
                    ref.read(ruleProvider.notifier).id(value);
                    enableCheck();
                  }
                )
              )
            ],
          )
        ]
      )
    );
  }
}