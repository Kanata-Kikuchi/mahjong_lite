import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

final double inputBoxHeight = 30;

class SelectSheet extends StatefulWidget {
  const SelectSheet({
    required this.title,
    required this.choices,
    required this.placeholder,
    required this.inputBoxWidth,
    required this.onChanged,
    super.key
  });

  final String title;
  final List<String> choices;
  final String placeholder;
  final double inputBoxWidth;
  final ValueChanged<String?> onChanged;

  @override
  State<SelectSheet> createState() => _SelectSheetState();
}

class _SelectSheetState extends State<SelectSheet> {

  String? _value;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final result = await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: Text(
                widget.title,
                style: MahjongTextStyle.sheetLabel
              ),
              actions: widget.choices.map((m) {
                return CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context, m),
                  child: Text(
                    m,
                    style: MahjongTextStyle.sheetChoiceBlue,
                  )
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "キャンセル",
                  style: MahjongTextStyle.sheetButtonCancel,
                )
              ),
            );
          },
        );

        if (result != null) {
          setState(() => _value = result);
          widget.onChanged(_value);
        }

      },
      child: Container(
        width: widget.inputBoxWidth,
        height: inputBoxHeight,
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CupertinoColors.systemGrey3,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              _value != null
                  ? "    $_value"
                  : widget.placeholder,
              style: _value != null
                  ? MahjongTextStyle.choiceBlue
                  : MahjongTextStyle.choiceOpa
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoColors.systemGrey,
            ),
          ],
        ),
      ),
    );
  }
}