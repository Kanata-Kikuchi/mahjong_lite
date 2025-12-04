import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/agari_flag_enum.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/button/tab_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/agari_notifier.dart';
import 'package:mahjong_lite/page/round_content_page/popup/inpu_revise/content/revise_ron.dart';
import 'package:mahjong_lite/page/round_content_page/popup/inpu_revise/content/revise_ryukyoku.dart';
import 'package:mahjong_lite/page/round_content_page/popup/inpu_revise/content/revise_tsumo.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class ReviseDialog extends ConsumerStatefulWidget {
  const ReviseDialog({super.key});

  @override
  ConsumerState<ReviseDialog> createState() => _ReviseDialogState();
}

class _ReviseDialogState extends ConsumerState<ReviseDialog> {

  int _selected = 0;
  bool _enable = false;

  void _check(bool enable) {
    setState(() => _enable = enable);
  }

  @override
  Widget build(BuildContext context) {

    final agari = ref.read(agariProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 200, vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(24)
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;

            return Column(
              children: [
                SizedBox(
                  height: h / 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TabBtn(
                        label: '  ロン  ',
                        selected: _selected == 0,
                        onTap: () => setState(() {
                          _enable = false;
                          _selected = 0;
                          agari.reset();
                          agari.flag(AgariFlag.ron);
                        })
                      ),
                      TabBtn(
                        label: '  ツモ  ',
                        selected: _selected == 1,
                        onTap: () => setState(() {
                          _enable = false;
                          _selected = 1;
                          agari.reset();
                          agari.flag(AgariFlag.tsumo);
                        })
                      ),
                      TabBtn(
                        label: '  流局  ',
                        selected: _selected == 2,
                        onTap: () => setState(() {
                          _enable = false;
                          _selected = 2;
                          agari.reset();
                          agari.flag(AgariFlag.ryukyou);
                        })
                      )
                    ]
                  ),
                ),
                ColumnDivider(),
                Expanded(
                  child: () {
                    if (_selected == 0) {return ReviseRon(check: _check);}
                    else if (_selected == 1) {return ReviseTsumo(check: _check);}
                    else {return ReviseRyukyoku(check: _check);}
                  }(),
                ),
                ColumnDivider(),
                SizedBox(
                  height: h / 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      EnableBtn(
                        label: '変更',
                        enabled: _enable,
                        red: true,
                        onTap: () {
                          Navigator.pop(context, true);
                          setState(() => _enable = false);
                        }
                      ),
                      CupertinoButton(
                        child: Text(
                          'キャンセル',
                          style: MahjongTextStyle.buttonCancel,
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                          agari.reset();
                          setState(() => _enable = false);
                        }
                      )
                    ],
                  ),
                )
              ]
            );
          },
        )
      )
    );
  }
}