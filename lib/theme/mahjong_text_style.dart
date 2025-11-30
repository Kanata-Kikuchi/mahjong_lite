import 'package:flutter/cupertino.dart';

class MahjongTextStyle {

  static const TextStyle tabBlue = TextStyle( // タブのボタン.
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.activeBlue
  );

  static const TextStyle tabGrey = TextStyle( // タブのボタン.
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.secondaryLabel
  );

  static const TextStyle tabAnnotation = TextStyle( // タブの注釈文字.
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

  static const TextStyle tabBlack = TextStyle( // タブの文字.
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.black
  );

  static const TextStyle buttonNext = TextStyle( // OKボタン.
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.activeBlue,
  );

  static const TextStyle buttonEnable = TextStyle( // 押せないボタン.
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.inactiveGray,
  );

  static const TextStyle buttonBack = TextStyle( // バックボタン.
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemRed,
  );

  static const TextStyle buttonCancel = TextStyle( // キャンセルボタン.
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black
  );

  static const TextStyle choiceLabel = TextStyle( // ボディのラベル文字.
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle choiceLabelL = TextStyle( // ボディのラベル文字、L.
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle choiceBlue = TextStyle( // 選択された文字.
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemBlue
  );

  static const TextStyle choiceBlueL = TextStyle( // 選択された文字、L.
    fontSize: 16,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemBlue
  );

  static const TextStyle choiceOpa = TextStyle( // 選択された文字.
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemGrey2
  );

  static const TextStyle scoreLabel = TextStyle( // スコアのラベル文字.
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle scoreAnotation = TextStyle( // スコアの注釈文字.
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

  static const TextStyle score = TextStyle( // スコア.
    fontSize: 50,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
    letterSpacing: 10
  );

  static const TextStyle roundTitle = TextStyle( // ラウンドタイトル.
    fontSize: 50,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
  );

  static const TextStyle title = TextStyle( // タイトル.
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
  );

  static const TextStyle tableLabel = TextStyle( // テーブルのラベル文字.
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle tableSel = TextStyle( // テーブルの中の文字.
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle tableAnotation = TextStyle( // テーブルの注釈文字.
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

}