import 'package:flutter/cupertino.dart';

class ColumnDivider extends StatelessWidget {
  const ColumnDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoColors.separator,
          ),
        ),
      )
    );
  }
}