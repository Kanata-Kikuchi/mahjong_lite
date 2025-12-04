import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class PopupRyuukyoku extends ConsumerStatefulWidget {
  const PopupRyuukyoku({
    super.key
  });

  @override
  ConsumerState<PopupRyuukyoku> createState() => _PopupRyuukyokuState();
}

class _PopupRyuukyokuState extends ConsumerState<PopupRyuukyoku> {

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
            Text(label[0]),
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
            Text(label[1]),
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
            Text(label[2]),
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
            Text(label[3])
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
            Text(label[0]),
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
            Text(label[1]),
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
            Text(label[2]),
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
            Text(label[3])
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final playerName = ref
        .read(playerProvider)
        .map((m) => m.name)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
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
                )
              ],
            )
          ),
          ColumnDivider(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
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
                )
              ],
            )
          ),
        ],
      )
    );
  }
}