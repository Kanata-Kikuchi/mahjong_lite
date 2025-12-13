enum Syanyu {
  none('なし'),
  ari('あり');

  final String label;
  const Syanyu(this.label);

  static List<String> get labels =>
      Syanyu.values.map((m) => m.label).toList();

  static Syanyu fromLabel(String label) {
    return Syanyu.values.firstWhere((w) => w.label == label);
  }
}