class Game {

  final int game;
  final int time;
  final (int, int) score1st;
  final (int, int) score2nd;
  final (int, int) score3rd;
  final (int, int) score4th;
  
  Game({
    required this.game,
    required this.time,
    required this.score1st,
    required this.score2nd,
    required this.score3rd,
    required this.score4th
  });

  Game copyWith({int? game, int? time, (int, int)? score1st, (int, int)? score2nd, (int, int)? score3rd, (int, int)? score4th}) {
    return Game(
      game: game ?? this.game,
      time: time ?? this.time,
      score1st: score1st ?? this.score1st,
      score2nd: score2nd ?? this.score2nd,
      score3rd: score3rd ?? this.score3rd,
      score4th: score4th ?? this.score4th
    );
  }
  
}