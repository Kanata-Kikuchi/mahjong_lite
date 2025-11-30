import 'package:mahjong_lite/model/agari_model.dart';

void debugPrintAgari(Agari? a) {
  if (a == null) {
    print('Agari = null');
    return;
  }

  print('''
===== AGARI DEBUG =====
flag       : ${a.flag}
reach      : ${a.reach}
tenpai     : ${a.tenpai}
houju      : ${a.houju}
agari      : ${a.agari}
score      : ${a.score}
childScore : ${a.childScore}
=======================
''');
}