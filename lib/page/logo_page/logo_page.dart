import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/room'),
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
        ),
      )
    );
  }
}
