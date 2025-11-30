import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/han_map.dart';
import 'package:mahjong_lite/data/hu_ron_map.dart';
import 'package:mahjong_lite/data/ron_child_score.dart';
import 'package:mahjong_lite/data/ron_host_score.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/notifier/revise_comment_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';
import 'package:mahjong_lite/layout/popup/select_sheet.dart';

class ReviseRon extends ConsumerStatefulWidget {
  const ReviseRon({
    required this.check,
    super.key
  });

  final Function(bool) check;

  @override
  ConsumerState<ReviseRon> createState() => _ReviseRonState();
}

class _ReviseRonState extends ConsumerState<ReviseRon> {

  int? houju;
  int? agari;
  int? han;
  int? hu;
  bool _hanSkipFlag = false;
  bool _huSkipFlag = false;
  final List<String> hanList = hanMap.keys.toList();
  final List<String> hanSkipList = hanMap.keys.skip(1).toList();
  final List<String> huList = huRonMap.keys.toList();
  final List<String> huSkipList = huRonMap.keys.skip(1).toList();

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
            Text(label[0]),
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
            Text(label[1]),
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
            Text(label[2]),
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
            Text(label[3])
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
              CupertinoRadio(value: 0),
              const SizedBox(width: 14),
              Text(label[0]),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              CupertinoRadio(value: 1),
              const SizedBox(width: 14),
              Text(label[1]),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              CupertinoRadio(value: 2),
              const SizedBox(width: 14),
              Text(label[2]),
            ],
          ),
          const SizedBox(width: 14),
          Row(
            children: [
              CupertinoRadio(value: 3),
              const SizedBox(width: 14),
              Text(label[3])
            ],
          )
        ],
      )
    );
  }

  void _calculateScore() { // ロン.

    if (han != null && hu != null && agari != null) {

      final p = ref.read(playerProvider) // 親のイニシャルを取る.
          .firstWhere((w) => w.zikaze == 0)
          .initial;

      if(agari == p) { // 親なら.
        int? score = keyRonHost[hu]?[han];

        if (score == null) { // keyRonHostになければ.
          if (han! < 6) {
            score = 12000;
          } else if (han! < 8) {
            score = 18000;
          } else if (han! < 11) {
            score = 24000;
          } else if (han! < 13) {
            score = 36000;
          } else {
            score = 48000;
          }
        }

        ref.read(agariProvider.notifier).score(score);
        _enableCheck();
      } else if (agari != p) { // 子なら.
        int? score = keyRonChild[hu]?[han];
        
        if (score == null) {
          if (han! < 6) {
            score = 8000;
          } else if (han! < 8) {
            score = 12000;
          } else if (han! < 11) {
            score = 16000;
          } else if (han! < 13) {
            score = 24000;
          } else {
            score = 32000;
          }
        }
        ref.read(agariProvider.notifier).score(score);
        _enableCheck();
      }
    }

  }

  void _enableCheck() {
    final enable = ref.read(agariProvider.notifier).checkRon();
    widget.check(enable && _textFlag);
  }

  @override
  Widget build(BuildContext context) {

    final playerName = ref
        .read(playerProvider)
        .map((m) => m.name)
        .toList();

    final text = ref.read(reviseCommentProvider.notifier);

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
                  child: _checkBtn(
                    label: playerName,
                    list: listReach
                  )
                )
              ],
            )
          ),
          ColumnDivider(),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      '放銃',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                Expanded(
                  child: _radioBtn(
                    label: playerName,
                    value: houju,
                    onChanged: (value) {
                      if (value != agari) { // 放銃と和了を排他に.
                        setState(() {
                          houju = value;
                          ref.read(agariProvider.notifier).houju(value);
                          _enableCheck();
                        });
                      }
                    }
                  ),
                )
              ],
            )
          ),
          ColumnDivider(),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
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
                    onChanged: (value) {
                      if (value != houju) { // 放銃と和了を排他に.
                        setState(() {
                          agari = value;
                          ref.read(agariProvider.notifier).agari(value);
                          _calculateScore();
                          _enableCheck();
                        });
                      }
                    }
                  ),
                )
              ],
            )
          ),
          ColumnDivider(),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
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
                        half: true,
                        onChanged: (value) => setState(() {

                          value == hanList[0]
                              ? _huSkipFlag = true
                              : _huSkipFlag = false;

                          han = hanMap[value];
                          _calculateScore();

                        }),
                      ),
                      SelectSheet(
                        title: '符',
                        choices: _huSkipFlag ? huSkipList : huList,
                        placeholder: '  符',
                        half: true,
                        onChanged: (value) => setState(() {

                          value == huList[0]
                              ? _hanSkipFlag = true
                              : _hanSkipFlag = false;
                              
                          hu = huRonMap[value];
                          _calculateScore();
                        }),
                      )
                    ],
                  )
                )
              ],
            )
          ),
          ColumnDivider(),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      'コメント',
                      style: MahjongTextStyle.tableLabel,
                    )
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _textFlag = false;
                        } else {
                          _textFlag = true;
                        }
                      });
                      text.set(value);
                      _enableCheck();
                    },
                  )
                )
              ],
            )
          )
        ],
      )
    );
  }
}