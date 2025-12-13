import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_lite/data/kyoku_map.dart';
import 'package:mahjong_lite/notifier/round_notifier.dart';
import 'package:mahjong_lite/theme/mahjong_text_style.dart';

class InputRoundMember extends ConsumerWidget {
  const InputRoundMember({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final round = ref.read(roundProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text( // ラウンド表記.
          '${kyokuMap[round.$1]} ${(round.$1) % 4 + 1} 局',
          style: MahjongTextStyle.roundTitle,
        ),
        const SizedBox.shrink()
      ],
    );
  }
}