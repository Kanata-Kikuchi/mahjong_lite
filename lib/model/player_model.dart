class Player {

  final String name;
  final int initial;
  int zikaze;
  int score;

  Player({
    required this.name,
    required this.initial,
    required this.zikaze,
    required this.score
  });

  Player copyWith({String? name, int? initial, int? zikaze, int? score}) {
    return Player(
      name: name ?? this.name,
      initial: initial ?? this.initial,
      zikaze: zikaze ?? this.zikaze,
      score: score ?? this.score
    );
  }

}