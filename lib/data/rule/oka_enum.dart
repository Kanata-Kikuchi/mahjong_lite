enum Oka {
  none20000('なし(20000点持ち)'),
  none25000('なし(25000点持ち)'),
  none30000('なし(30000点持ち)'),
  oka20_25('20000点持ち 25000点返し'),
  oka25_30('25000点持ち 30000点返し'),
  oka30_35('30000点持ち 35000点返し');

  final String label;
  const Oka(this.label);

  static List<String> get labels =>
      Oka.values.map((m) => m.label).toList();

  static Oka fromLabel(String label) {
    return Oka.values.firstWhere((w) => w.label == label);
  }
}
