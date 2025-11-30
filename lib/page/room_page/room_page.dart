import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/button/enable_btn.dart';
import 'package:mahjong_lite/layout/button/tab_btn.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/layout/layout_page.dart';
import 'package:mahjong_lite/page/room_page/room_page_content.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  int _selected = 0;
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
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
                            onTap: () => setState(() => _selected = 0)
                          ),
                          TabBtn(
                            label: 'ルームに入る',
                            selected: _selected == 1,
                            onTap: () => setState(() => _selected = 1)
                          )
                        ],
                      )
                    ),
                    ColumnDivider(),
                    Expanded(
                      child: RoomPageContent(
                        selected: _selected
                      )
                    ),
                    ColumnDivider(),
                    SizedBox( // フットボタン.
                      height: 60,
                      child: _selected == 0
                          ? EnableBtn(
                              label: "作る",
                              enabled: enabled,
                              onTap: () => Navigator.pushNamed(context, '/room_host')
                            )
                          : EnableBtn(
                              label: "入る",
                              enabled: enabled,
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