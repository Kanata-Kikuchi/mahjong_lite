import 'dart:math';
import 'package:flutter/cupertino.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Transform.rotate(
          angle: pi / 4,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {Navigator.pushNamedAndRemoveUntil(context, '/room', (route) => false)},
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey,
              ),
            ),
          )
        ),
      ),
    );
  }
}
