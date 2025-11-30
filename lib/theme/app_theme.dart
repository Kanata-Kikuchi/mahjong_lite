import 'package:flutter/cupertino.dart';

class AppTheme {

  static const CupertinoThemeData fallback = CupertinoThemeData(
    brightness: Brightness.light
  );

  static CupertinoThemeData fromMediaQuery(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = brightness == Brightness.dark;
    
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: CupertinoColors.activeBlue,
      barBackgroundColor: isDark ? CupertinoColors.black : CupertinoColors.systemGrey6,
      scaffoldBackgroundColor: isDark ? CupertinoColors.black : CupertinoColors.systemGrey6,
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          fontSize: 16,
          color: isDark ? CupertinoColors.white : CupertinoColors.label,
        ),
        navTitleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isDark ? CupertinoColors.white : CupertinoColors.label
        )
      )
    );
  }
}