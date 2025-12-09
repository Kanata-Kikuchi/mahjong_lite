import 'package:flutter/cupertino.dart';

class MahjongTextStyle {

  /*--------------------------------------- Button ---------------------------------------*/


  static const TextStyle buttonCancel = TextStyle( // キャンセルボタン.
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black
  );
  
  /*------------------ EnableBtn ------------------*/

  static const TextStyle buttonEnable = TextStyle( // 押せないボタン.
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.inactiveGray,
  );

  static const TextStyle buttonBackBold = TextStyle( // バックボタン.
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.systemRed,
  );

  static const TextStyle buttonBack = TextStyle( // バックボタン.
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemRed,
  );
  
  static const TextStyle buttonNextBold = TextStyle( // OKボタン.
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.activeBlue,
  );

  static const TextStyle buttonNext = TextStyle( // OKボタン.
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.activeBlue,
  );

  /*-------------------- TabBtn --------------------*/

  static const TextStyle tabBlue = TextStyle( // タブのボタン.
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.activeBlue
  );

  static const TextStyle tabGrey = TextStyle( // タブのボタン.
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.secondaryLabel
  );

  /*-------------------- BackBtn --------------------*/

  // + buttonBack, buttonNext.

  /*-------------------- NextBtn --------------------*/

  // + buttonNext.

  /*---------------------------------------- Popup ----------------------------------------*/

  /*------ PopupRon, PopupTsumo, PopupRyukyoku ------*/

  static const TextStyle tableLabel = TextStyle( // テーブルのラベル文字.
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  /*------------------------------------- SelectSheet -------------------------------------*/

  static const TextStyle sheetLabel = TextStyle( // タブの文字.
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey
  );

  static const TextStyle sheetChoiceBlue = TextStyle( // 選択済み.
    fontSize: 16,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemBlue
  );

  static const TextStyle sheetButtonCancel = TextStyle( // OKボタン.
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.activeBlue,
  );

  // + choiceBlue, choiceOpa

  /*---------------------------- RoomPage, RoomHost, RoomChild ----------------------------*/

  /*------------------- Button -------------------*/

  // + TabBtn, EnableBtn.

  /*------------------- Content -------------------*/

  static const TextStyle tabBlack = TextStyle( // タブの文字.
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black
  );

  static const TextStyle tabAnnotation = TextStyle( // タブの注釈文字.
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

  static const TextStyle choiceLabel = TextStyle( // ラベル.
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle choiceLabelL = TextStyle( // ボディのラベル文字、L.
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );

  static const TextStyle choiceBlue = TextStyle( // 選択済み.
    fontSize: 12,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemBlue
  );

  static const TextStyle choiceOpa = TextStyle( // プレースホルダー.
    fontSize: 12,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemGrey2
  );

  /*-------------------------------------- ScoreSharePage --------------------------------------*/


  /*-------------------- Button --------------------*/

  // + BackBtn, NextBtn.

  /*------------------- ScoreBox -------------------*/

  static const TextStyle scoreLabel = TextStyle( // スコアの名前表記.
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
  );

  static const TextStyle scoreAnotation = TextStyle( // スコアの注釈文字.
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

  static const TextStyle score = TextStyle( // スコア.
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
    letterSpacing: 8
  );

  /*------------- ExtraRound, ゲーム数表記 ------------*/

  // + scoreAnotation.

  /*------------- InputRound, FinishGame -------------*/

  static const TextStyle roundTitle = TextStyle( // ラウンドタイトル.
    fontSize: 30,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
  );

/*------------------------------------------ Table -------------------------------------------*/

// + tableLabel
/*
static const TextStyle tableLabel = TextStyle( // テーブルのラベル文字.
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );
 */
  static const TextStyle tableAnotation = TextStyle( // テーブルの注釈文字.
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.systemGrey,
  );

  static const TextStyle tableSel = TextStyle( // テーブルの中の文字.
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.black,
  );




  static const TextStyle choiceBlueL = TextStyle( // 選択された文字、L.
    fontSize: 16,
    fontWeight: FontWeight.w200,
    color: CupertinoColors.systemBlue
  );

  static const TextStyle title = TextStyle( // タイトル.
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: CupertinoColors.black,
  );


  

}