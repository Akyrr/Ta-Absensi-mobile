class Subject {
  final int id;
  final String code;
  final String name;

  const Subject({required this.id, required this.code, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}