class MasterStudent {
  final int id;
  final String name;
  final String nisn;
  final String? className;

  const MasterStudent({
    required this.id,
    required this.name,
    required this.nisn,
    this.className,
  });

  factory MasterStudent.fromJson(Map<String, dynamic> json) {
    final cls = json['class'];
    return MasterStudent(
      id: json['id'] as int,
      name: json['name'] as String,
      nisn: json['nisn'] as String,
      className: cls is Map<String, dynamic> ? cls['name'] as String? : null,
    );
  }
}