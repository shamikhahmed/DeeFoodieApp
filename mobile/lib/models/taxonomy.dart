class NamedEntry {
  const NamedEntry({required this.id, required this.name});

  final String id;
  final String name;

  factory NamedEntry.fromJson(Map<String, dynamic> json) =>
      NamedEntry(id: json['id'] as String, name: json['name'] as String);
}
