import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

/*
  <-space-> <---label---> <----------input----------> <-space->
  <-space-> <---label---> <-space->　<-----input-----> <-space->
*/

final double leftSpace = 20;
final double labelBoxWidth = 50;
final double labelInputSpace = 40;
final double inputBoxWidth = 80;
final double rightSpace = 40;

class ReviseRyukyoku extends ConsumerStatefulWidget {
  const ReviseRyukyoku({
    required this.commentController,
    required this.check,
    super.key
  });

  final TextEditingController commentController;
  final Function(bool) check;

  @override
  ConsumerState<ReviseRyukyoku> createState() => _ReviseRyukyokuState();
}

class _ReviseRyukyokuState extends ConsumerState<ReviseRyukyoku> {
  
  bool _textFlag = false;

  final List<bool> listReach = [
    false,
    false,
    false,
    false
  ];

  final List<bool> listTenpai = [
    false,
    false,
    false,
    false
  ];

  void linkList(int i) {
    if (listReach[i]) {
      listTenpai[i] = true;
      ref.read(agariProvider.notifier).tenpai(listTenpai);
    }
  }

  Widget _reachCheckBtn({
    required List<String> label,
  }) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listReach[0],
              onChanged: (value) => setState(() {
                listReach[0] = value ?? false;
                ref.read(agariProvider.notifier).reach(listReach);
                linkList(0);
              })
            ),
            Text(
              label[0],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listReach[1],
              onChanged: (value) => setState(() {
                listReach[1] = value ?? false;
                ref.read(agariProvider.notifier).reach(listReach);
                linkList(1);
              })
            ),
            Text(
              label[1],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listReach[2],
              onChanged: (value) => setState(() {
                listReach[2] = value ?? false;
                ref.read(agariProvider.notifier).reach(listReach);
                linkList(2);
              })
            ),
            Text(
              label[2],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listReach[3],
              onChanged: (value) => setState(() {
                listReach[3] = value ?? false;
                ref.read(agariProvider.notifier).reach(listReach);
                linkList(3);
              })
            ),
            Text(
              label[3],
              style: MahjongTextStyle.tableLabel,
            )
          ],
        )
      ],
    );
  }

  Widget _tenpaiCheckBtn({
    required List<String> label,
  }) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listTenpai[0],
              onChanged: (value) => setState(() {
                listTenpai[0] = value ?? false;
                ref.read(agariProvider.notifier).tenpai(listTenpai);
              })
            ),
            Text(
              label[0],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listTenpai[1],
              onChanged: (value) => setState(() {
                listTenpai[1] = value ?? false;
                ref.read(agariProvider.notifier).tenpai(listTenpai);
              })
            ),
            Text(
              label[1],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listTenpai[2],
              onChanged: (value) => setState(() {
                listTenpai[2] = value ?? false;
                ref.read(agariProvider.notifier).tenpai(listTenpai);
              })
            ),
            Text(
              label[2],
              style: MahjongTextStyle.tableLabel,
            ),
          ],
        ),
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: listTenpai[3],
              onChanged: (value) => setState(() {
                listTenpai[3] = value ?? false;
                ref.read(agariProvider.notifier).tenpai(listTenpai);
              })
            ),
            Text(
              label[3],
              style: MahjongTextStyle.tableLabel,
            )
          ],
        )
      ],
    );
  }

  void _enableCheck() {
    widget.check(_textFlag);
  }

  @override
  Widget build(BuildContext context) {

    final playerName = ref
        .read(playerProvider)
        .map((m) => m.name!)
        .toList();

    final text = ref.read(reviseCommentProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: leftSpace),
                SizedBox(
                  width: labelBoxWidth,
                  child: const Center(
                    child: Text(
                      'リーチ',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                Expanded(
                  child: _reachCheckBtn(
                    label: playerName,
                  )
                ),
                SizedBox(width: rightSpace)
              ],
            )
          ),
          const ColumnDivider(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: leftSpace),
                SizedBox(
                  width: labelBoxWidth,
                  child: const Center(
                    child: Text(
                      '聴牌',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                Expanded(
                  child: _tenpaiCheckBtn(
                    label: playerName,
                  )
                ),
                SizedBox(width: rightSpace)
              ],
            )
          ),
          const ColumnDivider(),
          Expanded(
            child: Row(
              children: [
                SizedBox(width: leftSpace),
                SizedBox(
                  width: labelBoxWidth,
                  child: const Center(
                    child: Text(
                      'コメント',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                SizedBox(width: labelInputSpace),
                Expanded(
                  child: CupertinoTextField(
                    controller: widget.commentController,
                    placeholder: '修正理由を書いてください',
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
                      setState(() {
                        if (value.isEmpty) {
                          _textFlag = false;
                        } else {
                          _textFlag = true;
                        }
                      });
                      text.set(
                        index: ref.read(roundTableProvider.notifier).reviseIndex(),
                        text: value
                      );
                      _enableCheck();
                    },
                  )
                ),
                SizedBox(width: rightSpace)
              ],
            )
          )
        ],
      )
    );
  }
}