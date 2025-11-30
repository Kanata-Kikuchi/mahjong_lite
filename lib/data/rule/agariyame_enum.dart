enum Agariyame {
  none('なし'),
  ari('あり');

  final String label;
  const Agariyame(this.label);

  static List<String> get labels =>
      Agariyame.values.map((m) => m.label).toList();
}