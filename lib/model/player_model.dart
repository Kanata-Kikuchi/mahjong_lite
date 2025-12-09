class Player {

  final String? playerId;
  final String? name;
  final int initial;
  final int zikaze;
  final int? score;

  Player({
    required this.playerId,
    required this.name,
    required this.initial,
    required this.zikaze,
    required this.score
  });

  Player copyWith({String? playerId, String? name, int? initial, int? zikaze, int? score}) {
    return Player(
      playerId: playerId ?? this.playerId,
      name: name ?? this.name,
      initial: initial ?? this.initial,
      zikaze: zikaze ?? this.zikaze,
      score: score ?? this.score
    );
  }

}