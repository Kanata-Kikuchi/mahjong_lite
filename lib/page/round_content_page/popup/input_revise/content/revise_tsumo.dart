import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/han_map.dart';
import 'package:mahjong_lite/data/hu_tsumo_map.dart';
import 'package:mahjong_lite/data/tsumo_child_score.dart';
import 'package:mahjong_lite/data/tsumo_host_score.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/notifier/round_table_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';
import 'package:mahjong_lite/layout/popup/select_sheet.dart';

/*
  <-space-> <---label---> <----------input----------> <-space->
  <-space-> <---label---> <-space->　<-----input-----> <-space->
*/

final double leftSpace = 20;
final double labelBoxWidth = 50;
final double labelInputSpace = 40;
final double inputBoxWidth = 120;
final double rightSpace = 40;

class ReviseTsumo extends ConsumerStatefulWidget {
  const ReviseTsumo({
    required this.commentController,
    required this.check,
    super.key
  });

  final TextEditingController commentController;
  final Function(bool) check;

  @override
  ConsumerState<ReviseTsumo> createState() => _ReviseTsumoState();
}

class _ReviseTsumoState extends ConsumerState<ReviseTsumo> {

  int? houjuu;
  int? agari;
  int? han;
  int? hu;
  bool _hanSkipFlag = false;
  bool _huSkipFlag = false;
  final List<String> hanList = hanMap.keys.toList();
  final List<String> hanSkipList = hanMap.keys.skip(1).toList();
  final List<String> huList = huTsumoMap.keys.toList();
  final List<String> huSkipList = huTsumoMap.keys.skip(2).toList();

  bool _textFlag = false;

  final List<bool> listReach = [
    false,
    false,
    false,
    false
  ];

  Widget _checkBtn({
    required List<String> label,
    required List<bool> list
  }) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox.shrink(),
        Row(
          children: [
            CupertinoCheckbox(
              value: list[0],
              onChanged: (value) => setState(() {
                list[0] = value ?? false;
                ref.read(agariProvider.notifier).reach(list);
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
              value: list[1],
              onChanged: (value) => setState(() {
                list[1] = value ?? false;
                ref.read(agariProvider.notifier).reach(list);
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
              value: list[2],
              onChanged: (value) => setState(() {
                list[2] = value ?? false;
                ref.read(agariProvider.notifier).reach(list);
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
              value: list[3],
              onChanged: (value) => setState(() {
                list[3] = value ?? false;
                ref.read(agariProvider.notifier).reach(list);
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

  Widget _radioBtn({
    required List<String> label,
    required int? value,
    required Function(int?) onChanged,
  }) {

    return RadioGroup<int>(
      groupValue: value,
      onChanged: onChanged,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 14),
          Row(
            children: [
              const CupertinoRadio(value: 0),
              const SizedBox(width: 14),
              Text(
                label[0],
                style: MahjongTextStyle.tableLabel,
              ),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              const CupertinoRadio(value: 1),
              const SizedBox(width: 14),
              Text(
                label[1],
                style: MahjongTextStyle.tableLabel,
              ),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              const CupertinoRadio(value: 2),
              const SizedBox(width: 14),
              Text(
                label[2],
                style: MahjongTextStyle.tableLabel,
              ),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              const CupertinoRadio(value: 3),
              const SizedBox(width: 14),
              Text(
                label[3],
                style: MahjongTextStyle.tableLabel,
              )
            ],
          )
        ],
      )
    );
  }

  void _calculateScore() { // ツモ.
    if (han != null && hu != null && agari != null) {

      final p = ref.read(playerProvider) // 親のイニシャルを取る.
          .firstWhere((w) => w.zikaze == 0)
          .initial;

      if(agari == p) { // 親なら.
        int? score = keyHostTsumo[hu]?[han];

        if (score == null) { // 後で３倍.
          if (han! < 6) {
            score = 4000;
          } else if (han! < 8) {
            score = 6000;
          } else if (han! < 11) {
            score = 8000;
          } else if (han! < 13) {
            score = 12000;
          } else {
            score = 16000;
          }
        }

        ref.read(agariProvider.notifier).score(score);
      } else if (agari != p) { // 子なら.
        int? hostScore = keyChildTsumo[hu]?[han]?.$2;
        int? childScore = keyChildTsumo[hu]?[han]?.$1;

        if (hostScore == null) {
          if (han! < 6) {
            hostScore = 4000;
          } else if (han! < 8) {
            hostScore = 6000;
          } else if (han! < 11) {
            hostScore = 8000;
          } else if (han! < 13) {
            hostScore = 12000;
          } else {
            hostScore = 16000;
          }
        }

        if (childScore == null) {
          if (han! < 6) {
            childScore = 2000;
          } else if (han! < 8) {
            childScore = 3000;
          } else if (han! < 11) {
            childScore = 4000;
          } else if (han! < 13) {
            childScore = 6000;
          } else {
            childScore = 8000;
          }
        }

        ref.read(agariProvider.notifier).score(hostScore);
        ref.read(agariProvider.notifier).childScore(childScore);
      }
    }
  }

  void _enableCheck() {
    final enable = ref.read(agariProvider.notifier).checkTsumo();
    widget.check(enable && _textFlag);
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
                  child: _checkBtn(
                    label: playerName,
                    list: listReach
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
                      '和了',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                Expanded(
                  child: _radioBtn(
                    label: playerName,
                    value: agari,
                    onChanged: (value) => setState(() {
                      agari = value;
                      ref.read(agariProvider.notifier).agari(value);
                      _calculateScore();
                      _enableCheck();
                    })
                  ),
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
                      '点数',
                      style: MahjongTextStyle.tableLabel,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SelectSheet(
                        title: '飜',
                        choices: _hanSkipFlag ? hanSkipList : hanList,
                        placeholder: '  飜',
                        inputBoxWidth: inputBoxWidth,
                        onChanged: (value) => setState(() {

                          value == hanList[0]
                              ? _huSkipFlag = true
                              : _huSkipFlag = false;

                          han = hanMap[value];
                          _calculateScore();
                          _enableCheck();

                        }),
                      ),
                      SelectSheet(
                        title: '符',
                        choices: _huSkipFlag ? huSkipList : huList,
                        placeholder: '  符',
                        inputBoxWidth: inputBoxWidth,
                        onChanged: (value) => setState(() {

                          value == huList[0] || value == huList[1]
                              ? _hanSkipFlag = true
                              : _hanSkipFlag = false;

                          hu = huTsumoMap[value];
                          _calculateScore();
                          _enableCheck();

                        }),
                      )
                    ],
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