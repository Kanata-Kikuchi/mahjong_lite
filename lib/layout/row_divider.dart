import 'package:flutter/cupertino.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CupertinoColors.separator,
            ),
          ),
        ),
      ),
    );
  }
}
