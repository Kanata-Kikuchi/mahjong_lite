import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/button/tab_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/notifier/ruleh_notifier.dart';
import 'package:mahjong_lite/page/room_page/child/content_child.dart';
import 'package:mahjong_lite/page/room_page/host/content_host.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {

  int _selected = 0;
  bool _enable = false;

  final nameController = TextEditingController(); // 画面切り替えても保持したいから親で管理.

  void _check(bool enable) {
    setState(() => _enable = enable);
  }

  @override
  Widget build(BuildContext context) {

    final rule = ref.read(ruleProvider.notifier);

    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 55),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              return LayoutPage( // 背景のポップ.
                width: w / 2,
                height: h,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox( // タブボタン.
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TabBtn(
                            label: 'ルームを作る',
                            selected: _selected == 0,
                            onTap: () {
                              setState(() {
                                _selected = 0;
                                _enable = false;
                              });
                              rule.reset();
                            }
                          ),
                          TabBtn(
                            label: 'ルームに入る',
                            selected: _selected == 1,
                            onTap: () {
                              setState(() {
                                _selected = 1;
                                _enable = false;
                              });
                              rule.reset();
                            }
                          )
                        ],
                      )
                    ),
                    ColumnDivider(),
                    Expanded(
                      child: _selected == 0
                          ? ContentHost(
                              nameController: nameController,
                              check: _check,
                            )
                          : ContentChild(
                              nameController: nameController,
                              check: _check,
                              )
                    ),
                    ColumnDivider(),
                    SizedBox( // フットボタン.
                      height: 60,
                      child: _selected == 0
                          ? EnableBtn(
                              label: "作る",
                              enabled: _enable,
                              onTap: () => Navigator.pushNamed(context, '/room_host')
                            )
                          : EnableBtn(
                              label: "入る",
                              enabled: _enable,
                              onTap: () => Navigator.pushNamed(context, '/room_child')
                            )
                    ),
                  ],
                ),
              );
            }
          )
        )
      )
    );
  }
}