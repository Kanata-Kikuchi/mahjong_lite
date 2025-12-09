import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/layout/column_divider.dart';
import 'package:mahjong_lite/notifier/player_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class NextGameContent extends ConsumerStatefulWidget {
  const NextGameContent({super.key});

  @override
  ConsumerState<NextGameContent> createState() => _NextGameContentState();
}

class _NextGameContentState extends ConsumerState<NextGameContent> {

 @override
  Widget build(BuildContext context) {

    final player = ref.read(playerProvider.notifier);
    final name = ref.read(playerProvider).map((m) => m.name!).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row( // 東.
            children: [
              Text(
                '東',
                style: MahjongTextStyle.choiceLabelL,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name[0],
                      style: MahjongTextStyle.choiceLabelL,
                    ),
                    ColumnDivider()
                  ],
                ),
              )
            ],
          ),
          GestureDetector( // 切り替えボタン.
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => player.changeTonNan()),
            child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
          ),
          Row( // 南.
            children: [
              Text(
                '南',
                style: MahjongTextStyle.choiceLabelL,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name[1],
                      style: MahjongTextStyle.choiceLabelL,
                    ),
                    ColumnDivider()
                  ],
                ),
              )
            ],
          ),
          GestureDetector( // 切り替えボタン.
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => player.changeNanSya()),
            child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
          ),
          Row( // 西.
            children: [
              Text(
                '西',
                style: MahjongTextStyle.choiceLabelL,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name[2],
                      style: MahjongTextStyle.choiceLabelL,
                    ),
                    ColumnDivider()
                  ],
                ),
              )
            ],
          ),
          GestureDetector( // 切り替えボタン.
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => player.changeSyaPei()),
            child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 15)
          ),
          Row( // 北.
            children: [
              Text(
                '北',
                style: MahjongTextStyle.choiceLabelL,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name[3],
                      style: MahjongTextStyle.choiceLabelL,
                    ),
                    ColumnDivider()
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}