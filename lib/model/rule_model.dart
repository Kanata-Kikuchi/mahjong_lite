import 'package:mahjong_lite/data/rule/agariyame_enum.dart';
import 'package:mahjong_lite/data/rule/oka_enum.dart';
import 'package:mahjong_lite/data/rule/syanyu_enum.dart';
import 'package:mahjong_lite/data/rule/tobi_enum.dart';
import 'package:mahjong_lite/data/rule/uma_enum.dart';

class Rule {

  final String name;
  final Uma uma;
  final Oka oka;
  final Tobi tobi;
  final Syanyu syanyu;
  final Agariyame agariyame;

  Rule({
    required this.name,
    required this.uma,
    required this.oka,
    required this.tobi,
    required this.syanyu,
    required this.agariyame
  });

  Rule copyWith({
    String? name,
    Uma? uma,
    Oka? oka,
    Tobi? tobi,
    Syanyu? syanyu,
    Agariyame? agariyame
  }) {
    return Rule(
      name: name ?? this.name,
      uma: uma ?? this.uma,
      oka: oka ?? this.oka,
      tobi: tobi ?? this.tobi,
      syanyu: syanyu ?? this.syanyu,
      agariyame: agariyame ?? this.agariyame
    );
  }

}