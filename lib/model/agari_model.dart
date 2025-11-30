import 'package:mahjong_lite/data/agari_flag_enum.dart';

class Agari {

  final AgariFlag? flag;
  final List<bool> reach; // 東：０、南：１、西：２、北：３.
  final List<bool> tenpai;
  final int? houju; // 上と一緒で東１局時の自風.
  final int? agari; // 上と一緒.
  final int? score;
  final int? childScore;
  final bool? revise;

  Agari({
    required this.flag,
    required this.reach,
    required this.tenpai,
    required this.houju,
    required this.agari,
    required this.score,
    required this.childScore,
    this.revise
  });

  Agari copyWith({
    (int, int)? round,
    AgariFlag? flag,
    List<bool>? reach,
    List<bool>? tenpai,
    int? houju,
    int? agari,
    int? score,
    int? childScore,
    bool? revise
  }) {

    return Agari(
      flag: flag ?? this.flag,
      reach: reach ?? this.reach,
      tenpai: tenpai ?? this.tenpai,
      houju: houju ?? this.houju,
      agari: agari ?? this.agari,
      score: score ?? this.score,
      childScore: childScore ?? this.childScore,
      revise: revise ?? this.revise
    );
  }

}