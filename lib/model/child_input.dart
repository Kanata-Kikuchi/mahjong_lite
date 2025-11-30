class Child {

  final String name;
  final String id;

  Child({
    required this.name,
    required this.id
  });

  Child copyWith({String? name, String? id}) {
    return Child(
      name: name ?? this.name,
      id: id ?? this.id
    );
  }

}