enum Tobi {
  none('なし'),
  ari('あり');

  final String label;
  const Tobi(this.label);

  static List<String> get labels =>
      Tobi.values.map((m) => m.label).toList();

  static Tobi fromLabel(String label) {
    return Tobi.values.firstWhere((w) => w.label == label);
  }
}