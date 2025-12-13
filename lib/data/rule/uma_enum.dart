enum Uma {

  none('なし'),
  uma5_10('5 - 10'),
  uma10_20('10 - 20'),
  uma10_30('10 - 30'),
  uma20_30('20 - 30');

  final String label;
  const Uma(this.label);

  static List<String> get labels =>
      Uma.values.map((m) => m.label).toList();

  static Uma fromLabel(String label) {
    return Uma.values.firstWhere((w) => w.label == label);
  }
}