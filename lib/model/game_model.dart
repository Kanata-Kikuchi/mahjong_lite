class Game {

  final String game;
  final int time;
  final (int, String)? score1st;
  final (int, String)? score2nd;
  final (int, String)? score3rd;
  final (int, String)? score4th;
  
  Game({
    required this.game,
    required this.time,
    this.score1st,
    this.score2nd,
    this.score3rd,
    this.score4th
  });

  Game copyWith({
    String? game,
    int? time,
    (int, String)? score1st,
    (int, String)? score2nd,
    (int, String)? score3rd,
    (int, String)? score4th
  }) {

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