class RoundTable {

  final String kyoku;
  final String honba;
  final int? p0;
  final int? p1;
  final int? p2;
  final int? p3;
  
  RoundTable({
    required this.kyoku,
    required this.honba,
    this.p0,
    this.p1,
    this.p2,
    this.p3
  });

  RoundTable copyWith({String? kyoku, String? honba, int? p0, int? p1, int? p2, int? p3}) {
    return RoundTable(
      kyoku: kyoku ?? this.kyoku,
      honba: honba ?? this.honba,
      p0: p0 ?? this.p0,
      p1: p1 ?? this.p1,
      p2: p2 ?? this.p2,
      p3: p3 ?? this.p3
    );
  }

}