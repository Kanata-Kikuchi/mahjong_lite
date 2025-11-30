import 'package:flutter/cupertino.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class PopupContent extends StatelessWidget {
  const PopupContent({
    required this.title,
    required this.anotation,
    required this.body,
    required this.footer,
    super.key
  });

  final String title;
  final String anotation;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 150, vertical: 50),
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
                  height: h / 8,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        SizedBox(width: 20),
                        Text(
                          title,
                          style: MahjongTextStyle.tabBlack,
                        ),
                        Text(
                          '  $anotation',
                          style: MahjongTextStyle.tabAnnotation,
                        )
                      ]
                    ),
                  )
                ),
                ColumnDivider(),
                Expanded(
                  child: body,
                ),
                ColumnDivider(),
                SizedBox(
                  height: h / 8,
                  child: footer,
                )
              ]
            );
          },
        )
      )
    );
  }
}